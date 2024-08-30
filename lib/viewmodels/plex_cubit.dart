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
    await _fetchToken();
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

  void extractMedia(String ip, String port) async {
    _moveLibrariesToLoading(ip, port);
    await _retrieveNewMedia(ip, port);
    final libraries = state.media;
    String? lastSuccessfulDate;
    for (final library in libraries) {
      print("Attempting to Extract ${library.name}");
      lastSuccessfulDate = await _populateLibrary(ip, port, library: library);
      print(
        "Extracted ${library.name} ${state.media.firstWhere(
          (element) => element.id == library.id,
        )}",
      );
    }
    if (lastSuccessfulDate != null) {
      if (state.recentToken != null) {
        _plexRepository.saveMedia(
          medias: state.media,
          recentIp: ip,
          recentPort: port,
          recentToken: state.recentToken!,
          lastSave: lastSuccessfulDate,
        );
        emit(
          state.copyWith(
            globalStatus: PlexStatus.loaded,
            lastSaved: lastSuccessfulDate,
          ),
        );
      } else {
        emit(
          state.copyWith(
            plexLoginStatus: PlexLoginStatus.noAuthToken,
            error: "Auth token invalid, Login",
          ),
        );
      }
    } else {
      getSavedMedia();
    }
  }

  Future<String?> _populateLibrary(
    String ip,
    String port, {
    required PlexLibrary library,
  }) async {
    List<PlexLibrary> newMedia = [...state.media];
    final index = newMedia.indexWhere((element) => element.id == library.id);
    try {
      if (state.recentToken != null) {
        final items = await _plexRepository
            .getMedia(ip, port, state.recentToken!, media: library);
        newMedia[index] =
            library.copyWith(items: items, status: PlexStatus.loaded);
        emit(state.copyWith(media: [...newMedia]));
        return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
      } else {
        emit(
          state.copyWith(
            plexLoginStatus: PlexLoginStatus.noAuthToken,
            error: "Auth token invalid, Login",
          ),
        );
        return null;
      }
    } catch (e) {
      newMedia[index] = library.copyWith(items: [], status: PlexStatus.error);
      emit(state.copyWith(media: [...newMedia]));
      return null;
    }
  }

  Future<void> _retrieveNewMedia(String ip, String port) async {
    try {
      if (state.recentToken != null) {
        final libraries =
            await _plexRepository.getLibraries(ip, port, state.recentToken!);
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
      } else {
        emit(state.copyWith());
      }
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

  Future<String?> _fetchToken() async {
    emit(state.copyWith(plexLoginStatus: PlexLoginStatus.loading));
    final token = await _plexRepository.recentToken;
    final savedUsername = await _plexRepository.savedUsername;
    if (token != null) {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.hasAuthToken,
          recentToken: token,
          savedUsername: savedUsername,
        ),
      );
    } else {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.noAuthToken,
          recentToken: token,
          savedUsername: savedUsername,
        ),
      );
    }
    return token;
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(plexLoginStatus: PlexLoginStatus.loading));
    String? token =
        await _plexRepository.login(username: username, password: password);
    if (token != null) {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.hasAuthToken,
          recentToken: token,
          savedUsername: username,
        ),
      );
    } else {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.noAuthToken,
          recentToken: token,
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(plexLoginStatus: PlexLoginStatus.loading));
    _plexRepository.logout();
    emit(state.resetToken());
  }

  void _moveLibrariesToLoading(String ip, String port) {
    List<PlexLibrary> library = [];
    for (var element in state.media) {
      library.add(element.copyWith(status: PlexStatus.loading));
    }
    emit(
      state.copyWith(
        recentIp: ip,
        recentPort: port,
        media: library,
        globalStatus: PlexStatus.loading,
      ),
    );
  }
}
