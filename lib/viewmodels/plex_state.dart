import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/media.dart';

class PlexState extends Equatable {
  final Map<String, List<Media>> media;
  final PlexStatus status;
  final String? recentIp;
  final int? recentPort;
  final String? error;
  final String? lastSaved;

  const PlexState({
    required this.recentIp,
    required this.recentPort,
    required this.media,
    required this.status,
    required this.lastSaved,
    this.error,
  });

  PlexState.init()
      : lastSaved = null,
        status = PlexStatus.init,
        media = {},
        recentIp = null,
        recentPort = null,
        error = null;

  PlexState copyWith({
    Map<String, List<Media>>? media,
    PlexStatus? status,
    String? recentIp,
    int? recentPort,
    String? error,
    String? lastSaved,
  }) {
    return PlexState(
      recentIp: recentIp ?? this.recentIp,
      recentPort: recentPort ?? this.recentPort,
      error: error ?? this.error,
      media: media ?? this.media,
      status: status ?? this.status,
      lastSaved: lastSaved ?? this.lastSaved,
    );
  }

  @override
  List<Object?> get props => [
        status,
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
