import 'package:equatable/equatable.dart';
import 'package:plextractor/models/user_credentials.dart';
import 'package:plextractor/viewmodels/plex_library.dart';

class PlexState extends Equatable {
  final List<PlexLibrary> libraries;
  final UserCredentials credentials;
  final String? error;
  final String? lastSaved;
  final PlexStatus globalStatus;
  final PlexLoginStatus plexLoginStatus;

  final bool show4k;
  final bool showOther;
  final bool show1080;

  const PlexState({
    required this.libraries,
    required this.lastSaved,
    required this.globalStatus,
    required this.plexLoginStatus,
    required this.credentials,
    this.error,
    this.show4k = true,
    this.showOther = true,
    this.show1080 = true,
  });
  PlexState.init()
      : lastSaved = null,
        libraries = [],
        error = null,
        credentials = const UserCredentials(),
        plexLoginStatus = PlexLoginStatus.noAuthToken,
        globalStatus = PlexStatus.init,
        show4k = true,
        showOther = true,
        show1080 = true;

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
    bool? show4k,
    bool? showOther,
    bool? show1080,
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
      show4k: show4k ?? this.show4k,
      showOther: showOther ?? this.showOther,
      show1080: show1080 ?? this.show1080,
    );
  }

  @override
  List<Object?> get props => [
        libraries,
        credentials,
        lastSaved,
        plexLoginStatus,
        error,
        show4k,
        showOther,
        show1080,
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
