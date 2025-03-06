import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/user_credentials.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';

class PlexState extends Equatable {
  final List<PlexLibrary> libraries;
  final UserCredentials credentials;
  final String? error;
  final String? lastSaved;
  final PlexStatus globalStatus;
  final PlexLoginStatus plexLoginStatus;

  const PlexState({
    required this.libraries,
    required this.lastSaved,
    required this.globalStatus,
    required this.plexLoginStatus,
    required this.credentials,
    this.error,
  });
  PlexState.init()
      : lastSaved = null,
        libraries = [],
        error = null,
        credentials = const UserCredentials(),
        plexLoginStatus = PlexLoginStatus.noAuthToken,
        globalStatus = PlexStatus.init;

  PlexState resetToken() => PlexState(
        credentials: UserCredentials(
          authToken: null,
          ip: credentials.ip,
          port: credentials.port,
          username: credentials.username,
        ),
        libraries: libraries,
        lastSaved: lastSaved,
        globalStatus: globalStatus,
        plexLoginStatus: PlexLoginStatus.noAuthToken,
      );

  PlexState copyWith({
    List<PlexLibrary>? media,
    String? ip,
    String? port,
    String? authToken,
    String? username,
    String? error,
    String? lastSaved,
    PlexStatus? globalStatus,
    PlexLoginStatus? plexLoginStatus,
  }) {
    return PlexState(
      credentials: UserCredentials(
        ip: ip ?? credentials.ip,
        port: port ?? credentials.port,
        authToken: authToken ?? credentials.authToken,
        username: username ?? credentials.username,
      ),
      error: error ?? this.error,
      libraries: media ?? libraries,
      globalStatus: globalStatus ?? this.globalStatus,
      lastSaved: lastSaved ?? this.lastSaved,
      plexLoginStatus: plexLoginStatus ?? this.plexLoginStatus,
    );
  }

  @override
  List<Object?> get props => [
        libraries,
        credentials,
        lastSaved,
        plexLoginStatus,
        error,
      ];
}

enum PlexStatus {
  init,
  loading,
  loaded,
  error;
}

enum PlexLoginStatus {
  noAuthToken,
  hasAuthToken,
  loading;
}
