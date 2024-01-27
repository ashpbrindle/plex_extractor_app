import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(PlexState.init()) {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await getSavedMedia();
  }

  final PlexRepository _plexRepository;
  late SharedPreferences prefs;

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

    if (extractedMedia.isEmpty) {
      emit(
        state.copyWith(
          media: {},
          status: PlexStatus.error,
          error: "Failed to fetch saved media. Please Connect",
        ),
      );
    } else {
      emit(
        state.copyWith(
          media: extractedMedia,
          status: PlexStatus.loaded,
          error: null,
          lastSaved: lastSave,
        ),
      );
    }
  }

  String get recentIp => prefs.getString('recentIp') ?? "";
  int? get recentPort => prefs.getInt('recentPort');

  void extractMedia(String ip, int port) async {
    emit(state.copyWith(status: PlexStatus.loading));
    emit(
      state.copyWith(
        recentIp: recentIp,
        recentPort: recentPort,
        error: null,
      ),
    );
    Map<String, List<Media>>? media;
    String lastSuccessfulDate = "";
    try {
      media = await _plexRepository.extractEverything(ip, port);
      lastSuccessfulDate =
          DateFormat('dd/MM/yyyy HH:MM').format(DateTime.now());
      emit(
        state.copyWith(
          status: PlexStatus.loaded,
          media: media,
          lastSaved: lastSuccessfulDate,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: PlexStatus.error,
            media: state.media,
            error: "Error Extracting Movies from Plex,\n $e"),
      );
    }
    _save(media ?? state.media, ip, port, lastSuccessfulDate);
  }

  Future<void> _save(
    Map<String, List<Media>> media,
    String recentIp,
    int recentPort,
    String? lastSave,
  ) async {
    String full = "";
    for (var media in media.entries) {
      if (full.isEmpty) {
        full = "${media.key},${jsonEncode(media.value)}";
      } else {
        full = "$full;${media.key},${jsonEncode(media.value)}";
      }
    }
    lastSave != null ? await prefs.setString('lastSaveMovie', lastSave) : null;
    await prefs.setString('media', full);
    await prefs.setString('recentIp', recentIp);
    await prefs.setInt('recentPort', recentPort);
  }
}
