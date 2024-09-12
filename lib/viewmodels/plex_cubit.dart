import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(PlexState.init());

  final PlexRepository _plexRepository;

  /// Fetches any saved token, and retrieves any saved list of media from previous refreshes
  Future<void> init() async {
    await _fetchToken();
    final (
      List<PlexLibrary> media,
      String? lastSave,
    ) = await _plexRepository.retrieveSavedMedia();
    emit(
      state.copyWith(
        media: media,
        globalStatus: PlexStatus.loaded,
        error: null,
        lastSaved: lastSave,
      ),
    );
    listenToUpdates();
  }

  Future<void> showHideLibrary(String name) async {
    List<PlexLibrary> libraries = [...state.libraries];
    final updatedLibraries = libraries.map((library) {
      if (library.name == name) {
        return library.copyWith(visible: !library.visible);
      } else {
        return library;
      }
    }).toList();

    emit(
      state.copyWith(
        media: updatedLibraries,
      ),
    );
  }

  Future<void> listenToUpdates() async {
    final ReceivePort receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      'libraryCountUpdate',
    );

    receivePort.listen((dynamic data) {
      final parsedMessage = data.toString().split(',');
      final libraryName = parsedMessage[0];
      final total = int.parse(parsedMessage[1]);
      final count = int.parse(parsedMessage[2]);
      List<PlexLibrary> libraries = [...state.libraries];
      final updatedLibraries = libraries.map((library) {
        if (library.id == libraryName) {
          print("${library.name}: $count/$total");
          return library.copyWith(
            total: total,
            count: count,
          );
        } else {
          return library;
        }
      }).toList();

      emit(
        state.copyWith(
          media: updatedLibraries,
        ),
      );
    });
  }

  /// Moves to a loading state and retrieves media from the provided ip and port
  void extractMedia(String ip, String port) async {
    // Moves to Loading PlexStatus
    _plexLoadingStatus(ip, port);
    // Retrieves all libraries for the provided ip and port, and emits the value of empty libraries
    final libraries = await _retrieveNewMedia(ip, port);
    String? lastSuccessfulDate;
    // Retrieves all media for the provided libraries
    for (final library in libraries) {
      print("Attempting to Extract ${library.name}");
      lastSuccessfulDate = await _populateLibrary(ip, port, library: library);
      print(
        "Extracted ${library.name} ${state.libraries.firstWhere(
          (element) => element.id == library.id,
        )}",
      );
    }
    if (lastSuccessfulDate != null) {
      if (state.credentials.authToken != null) {
        await _plexRepository.saveMedia(
          libraries: state.libraries,
          lastSave: lastSuccessfulDate,
        );
        await _plexRepository.saveCredentials(
          recentIp: ip,
          recentPort: port,
          recentToken: state.credentials.authToken!,
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
      init();
    }
  }

  /// Populates a PlexLibrary after it has been retrieved and will return a String of the timestamp it was retrieved
  Future<String?> _populateLibrary(
    String ip,
    String port, {
    required PlexLibrary library,
  }) async {
    List<PlexLibrary> newMedia = [...state.libraries];
    final index = newMedia.indexWhere((element) => element.id == library.id);
    try {
      if (state.credentials.authToken != null) {
        final items = await _plexRepository
            .getMedia(ip, port, state.credentials.authToken!, media: library);
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

  /// Retrieves all the libraries available on the server (Initial state is empty and will have to be populated after using [Future<String?> _populateLibrary(String ip, String port, {required PlexLibrary library,})])
  Future<List<PlexLibrary>> _retrieveNewMedia(String ip, String port) async {
    try {
      if (state.credentials.authToken != null) {
        final libraries = await _plexRepository.getLibraries(
            ip, port, state.credentials.authToken!);
        List<PlexLibrary> plexLibraries = [];
        libraries.forEach(
          (id, name) => plexLibraries.add(
            PlexLibrary(
              name: name,
              id: id,
              medias: const [],
              status: PlexStatus.loading,
            ),
          ),
        );
        print("Found ${state.libraries.map((e) => e.name)}");
        emit(state.copyWith(media: [...plexLibraries]));
        return plexLibraries;
      }
      return [];
    } catch (e) {
      List<PlexLibrary> newMedia = [...state.libraries];
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
      return newMedia;
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
          authToken: token,
          username: savedUsername,
        ),
      );
    } else {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.noAuthToken,
          authToken: token,
          username: savedUsername,
        ),
      );
    }
    return token;
  }

  Future<bool> login(
    String username,
    String password, {
    String? code,
  }) async {
    emit(state.copyWith(plexLoginStatus: PlexLoginStatus.loading));
    String? token = await _plexRepository.login(
      username: username,
      password: password,
      code: code,
    );
    if (token != null) {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.hasAuthToken,
          authToken: token,
          username: username,
        ),
      );
      return true;
    } else {
      emit(
        state.copyWith(
          plexLoginStatus: PlexLoginStatus.noAuthToken,
          error: "Invalid Login Credentials, Try again",
          authToken: token,
        ),
      );
      return false;
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(plexLoginStatus: PlexLoginStatus.loading));
    _plexRepository.logout();
    emit(state.resetToken());
  }

  void _plexLoadingStatus(String ip, String port) {
    List<PlexLibrary> library = [];
    for (var element in state.libraries) {
      library.add(element.copyWith(status: PlexStatus.loading));
    }
    emit(
      state.copyWith(
        ip: ip,
        port: port,
        media: library,
        globalStatus: PlexStatus.loading,
      ),
    );
  }
}
