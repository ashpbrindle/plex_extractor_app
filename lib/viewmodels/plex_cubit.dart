import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(PlexState.init()) {
    _init();
  }

  final PlexRepository _plexRepository;
  late SharedPreferences prefs;

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
    getSavedMedia();
  }

  Future<void> getSavedMedia() async {
    final medias = prefs.getString('media')?.split(";");
    final lastSave = prefs.getString("lastSave");
    Map<String, List<Media>> extractedMedia = {};
    if (medias != null) {
      for (final media in medias) {
        List<Movie> extractedMovies = [];
        List<TvShow> extractedTv = [];
        final temp = media.split(",");
        final name = temp.first;
        final listOfMedias = temp.sublist(1).join(",");
        if (listOfMedias.contains('"type":"movie"')) {
          final movies = jsonDecode(listOfMedias);
          for (var movie in movies) {
            extractedMovies.add(Movie.fromJson(movie));
          }
          extractedMedia.putIfAbsent(name, () => extractedMovies);
        } else if (listOfMedias.contains('"type":"tvShow"')) {
          final shows = jsonDecode(listOfMedias);
          for (var show in shows) {
            extractedTv.add(TvShow.fromJson(show));
          }
          extractedMedia.putIfAbsent(name, () => extractedTv);
        }
      }
    }

    emit(
      state.copyWith(
        media: extractedMedia.entries
            .map(
              (entry) => PlexLibrary(
                name: entry.key,
                id: "",
                items: entry.value,
                status: PlexStatus.loaded,
              ),
            )
            .toList(),
        globalStatus: PlexStatus.loaded,
        error: null,
        lastSaved: lastSave,
      ),
    );
  }

  String get recentIp => prefs.getString('recentIp') ?? "";
  int? get recentPort => prefs.getInt('recentPort');

  void extractMedia(String ip, int port) async {
    _moveLibrariesToLoading(ip, port);
    await _retrieveNewMedia(ip, port);
    final libraries = state.media;
    for (final library in libraries) {
      print("Attempting to Extract ${library.name}");
      await _populateLibrary(ip, port, library: library);
      print(
        "Extracted ${library.name} ${state.media.firstWhere(
          (element) => element.id == library.id,
        )}",
      );
    }
    String lastSuccessfulDate =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    _save(state.media, ip, port, lastSuccessfulDate);
    print(DateTime.now());
    emit(
      state.copyWith(
        globalStatus: PlexStatus.loaded,
        lastSaved: lastSuccessfulDate,
      ),
    );
  }

  Future<void> _populateLibrary(
    String ip,
    int port, {
    required PlexLibrary library,
  }) async {
    List<PlexLibrary> newMedia = [...state.media];
    final index = newMedia.indexWhere((element) => element.id == library.id);
    try {
      final items = await _plexRepository.getMedia(ip, port, media: library);
      newMedia[index] =
          library.copyWith(items: items, status: PlexStatus.loaded);
      emit(state.copyWith(media: [...newMedia]));
    } catch (e) {
      newMedia[index] = library.copyWith(items: [], status: PlexStatus.error);
      emit(state.copyWith(media: [...newMedia]));
    }
  }

  Future<void> _retrieveNewMedia(String ip, int port) async {
    final libraries = await _plexRepository.getLibraries(ip, port);
    List<PlexLibrary> plexLibraries = [];
    libraries.forEach(
      (id, name) => plexLibraries.add(
        PlexLibrary(
          name: name,
          id: id,
          items: const [],
          status: PlexStatus.loading,
        ),
      ),
    );
    emit(state.copyWith(media: [...plexLibraries]));
    print("Found ${state.media.map((e) => e.name)}");
  }

  void _moveLibrariesToLoading(String ip, int port) {
    List<PlexLibrary> library = [];
    for (var element in state.media) {
      library.add(element.copyWith(status: PlexStatus.loading));
    }
    emit(
      PlexState(
        recentIp: ip,
        recentPort: port,
        media: library,
        lastSaved: state.lastSaved,
        globalStatus: PlexStatus.loading,
        error: null,
      ),
    );
  }

  Future<void> _save(
    List<PlexLibrary> media,
    String recentIp,
    int recentPort,
    String? lastSave,
  ) async {
    String full = "";
    for (var media in media) {
      if (full.isEmpty) {
        final json = jsonEncode(media.items);
        full = "${media.name},$json";
      } else {
        full = "$full;${media.name},${jsonEncode(media.items)}";
      }
    }
    lastSave != null ? await prefs.setString('lastSave', lastSave) : null;
    await prefs.setString('media', full);
    await prefs.setString('recentIp', recentIp);
    await prefs.setInt('recentPort', recentPort);
  }
}
