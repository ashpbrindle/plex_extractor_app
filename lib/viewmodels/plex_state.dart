import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';

class PlexState extends Equatable {
  final List<PlexLibrary> media;
  final String? recentIp;
  final int? recentPort;
  final String? error;
  final String? lastSaved;
  final PlexStatus globalStatus;

  const PlexState({
    required this.recentIp,
    required this.recentPort,
    required this.media,
    required this.lastSaved,
    required this.globalStatus,
    this.error,
  });

  PlexState.init()
      : lastSaved = null,
        media = [],
        recentIp = null,
        recentPort = null,
        error = null,
        globalStatus = PlexStatus.init;

  PlexState copyWith({
    List<PlexLibrary>? media,
    String? recentIp,
    int? recentPort,
    String? error,
    String? lastSaved,
    PlexStatus? globalStatus,
  }) {
    return PlexState(
      recentIp: recentIp ?? this.recentIp,
      recentPort: recentPort ?? this.recentPort,
      error: error ?? this.error,
      media: media ?? this.media,
      globalStatus: globalStatus ?? this.globalStatus,
      lastSaved: lastSaved ?? this.lastSaved,
    );
  }

  @override
  List<Object?> get props => [
        media,
        recentIp,
        recentPort,
        lastSaved,
        error,
      ];
}

enum PlexStatus {
  init,
  loading,
  loaded,
  error;
}
