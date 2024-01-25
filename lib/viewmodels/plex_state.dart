import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';

class PlexState extends Equatable {
  final PlexStatus movieStatus;
  final PlexStatus tvShowStatus;
  final List<Movie> movies;
  final List<TvShow> tvShow;
  final String? recentIp;
  final int? recentPort;
  final String? error;
  final String? lastSavedMovie;
  final String? lastSavedTvShow;

  const PlexState({
    required this.movieStatus,
    required this.tvShowStatus,
    required this.movies,
    required this.tvShow,
    required this.recentIp,
    required this.recentPort,
    required this.lastSavedMovie,
    required this.lastSavedTvShow,
    this.error,
  });

  PlexState.init()
      : tvShowStatus = PlexStatus.init,
        movieStatus = PlexStatus.init,
        movies = [],
        tvShow = [],
        recentIp = null,
        recentPort = null,
        error = null,
        lastSavedMovie = null,
        lastSavedTvShow = null;

  PlexState copyWith({
    List<Movie>? movies,
    List<TvShow>? tvShow,
    PlexStatus? movieStatus,
    PlexStatus? tvShowStatus,
    String? recentIp,
    int? recentPort,
    String? error,
    String? lastSavedMovie,
    String? lastSavedTvShow,
  }) {
    return PlexState(
      movieStatus: movieStatus ?? this.movieStatus,
      tvShowStatus: tvShowStatus ?? this.tvShowStatus,
      movies: movies ?? this.movies,
      tvShow: tvShow ?? this.tvShow,
      recentIp: recentIp ?? this.recentIp,
      recentPort: recentPort ?? this.recentPort,
      error: error ?? this.error,
      lastSavedMovie: lastSavedMovie ?? this.lastSavedMovie,
      lastSavedTvShow: lastSavedTvShow ?? this.lastSavedTvShow,
    );
  }

  @override
  List<Object?> get props => [
        movieStatus,
        tvShowStatus,
        movies,
        tvShow,
        recentIp,
        recentPort,
        lastSavedMovie,
        lastSavedTvShow,
        error,
      ];
}

enum PlexStatus {
  init,
  loading,
  loaded,
  error;
}
