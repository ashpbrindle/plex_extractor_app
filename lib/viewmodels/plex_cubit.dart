import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(PlexState.init()) {
    getSavedMedia();
  }

  final PlexRepository _plexRepository;

  Future<void> getSavedMedia() async {
    final (List<PlexLibrary> media, String? lastSave) =
        await _plexRepository.retrieveSavedMedia();
    emit(
      state.copyWith(
        media: media,
        globalStatus: PlexStatus.loaded,
        error: null,
        lastSaved: lastSave,
      ),
    );
  }

  void extractMedia(String ip, String port, String token) async {
    _moveLibrariesToLoading(ip, port, token);
    await _retrieveNewMedia(ip, port, token);
    final libraries = state.media;
    String? lastSuccessfulDate;
    for (final library in libraries) {
      print("Attempting to Extract ${library.name}");
      lastSuccessfulDate =
          await _populateLibrary(ip, port, token, library: library);
      print(
        "Extracted ${library.name} ${state.media.firstWhere(
          (element) => element.id == library.id,
        )}",
      );
    }
    if (lastSuccessfulDate != null) {
      _plexRepository.saveMedia(
        medias: state.media,
        recentIp: ip,
        recentPort: port,
        recentToken: token,
        lastSave: lastSuccessfulDate,
      );
      emit(
        state.copyWith(
          globalStatus: PlexStatus.loaded,
          lastSaved: lastSuccessfulDate,
        ),
      );
    } else {
      getSavedMedia();
    }
  }

  Future<String?> _populateLibrary(
    String ip,
    String port,
    String plexToken, {
    required PlexLibrary library,
  }) async {
    List<PlexLibrary> newMedia = [...state.media];
    final index = newMedia.indexWhere((element) => element.id == library.id);
    try {
      final items =
          await _plexRepository.getMedia(ip, port, plexToken, media: library);
      newMedia[index] =
          library.copyWith(items: items, status: PlexStatus.loaded);
      emit(state.copyWith(media: [...newMedia]));
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    } catch (e) {
      newMedia[index] = library.copyWith(items: [], status: PlexStatus.error);
      emit(state.copyWith(media: [...newMedia]));
      return null;
    }
  }

  Future<void> _retrieveNewMedia(String ip, String port, String token) async {
    try {
      final libraries = await _plexRepository.getLibraries(ip, port, token);
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
    } catch (e) {
      List<PlexLibrary> newMedia = [...state.media];
      for (int i = 0; i < newMedia.length; i++) {
        newMedia[i] = newMedia[i].copyWith(status: PlexStatus.error);
      }
      emit(
        state.copyWith(
          globalStatus: PlexStatus.error,
          error: "$e",
          media: [...newMedia],
        ),
      );
    }
  }

  void _moveLibrariesToLoading(String ip, String port, String token) {
    List<PlexLibrary> library = [];
    for (var element in state.media) {
      library.add(element.copyWith(status: PlexStatus.loading));
    }
    emit(
      PlexState(
        recentIp: ip,
        recentPort: port,
        recentToken: token,
        media: library,
        lastSaved: state.lastSaved,
        globalStatus: PlexStatus.loading,
        error: null,
      ),
    );
  }
}
