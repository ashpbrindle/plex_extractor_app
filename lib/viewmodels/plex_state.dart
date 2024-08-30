import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class PlexState extends Equatable {
  final List<PlexLibrary> media;
  final String? recentIp;
  final String? recentPort;
  final String? recentToken;
  final String? error;
  final String? lastSaved;
  final String? savedUsername;
  final PlexStatus globalStatus;
  final PlexLoginStatus plexLoginStatus;

  const PlexState({
    required this.recentIp,
    required this.recentPort,
    required this.recentToken,
    required this.media,
    required this.lastSaved,
    required this.globalStatus,
    required this.plexLoginStatus,
    required this.savedUsername,
    this.error,
  });

  PlexState.init()
      : lastSaved = null,
        media = [],
        recentIp = null,
        recentPort = null,
        recentToken = null,
        error = null,
        savedUsername = null,
        plexLoginStatus = PlexLoginStatus.noAuthToken,
        globalStatus = PlexStatus.init;

  PlexState resetToken() => PlexState(
        recentIp: recentIp,
        recentPort: recentPort,
        recentToken: null,
        media: media,
        lastSaved: lastSaved,
        globalStatus: globalStatus,
        plexLoginStatus: PlexLoginStatus.noAuthToken,
        savedUsername: savedUsername,
      );

  PlexState copyWith({
    List<PlexLibrary>? media,
    String? recentIp,
    String? recentPort,
    String? recentToken,
    String? error,
    String? lastSaved,
    String? savedUsername,
    PlexStatus? globalStatus,
    PlexLoginStatus? plexLoginStatus,
  }) {
    return PlexState(
      savedUsername: savedUsername ?? this.savedUsername,
      recentIp: recentIp ?? this.recentIp,
      recentPort: recentPort ?? this.recentPort,
      recentToken: recentToken ?? this.recentToken,
      error: error ?? this.error,
      media: media ?? this.media,
      globalStatus: globalStatus ?? this.globalStatus,
      lastSaved: lastSaved ?? this.lastSaved,
      plexLoginStatus: plexLoginStatus ?? this.plexLoginStatus,
    );
  }

  @override
  List<Object?> get props => [
        media,
        recentIp,
        recentPort,
        recentToken,
        lastSaved,
        plexLoginStatus,
        error,
        savedUsername
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
