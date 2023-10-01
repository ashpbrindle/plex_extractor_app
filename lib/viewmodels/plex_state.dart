import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';

class PlexState extends Equatable {
  final PlexStatus movieStatus;
  final PlexStatus tvShowStatus;
  final List<Movie> movies;
  final List<TvShow> tvShow;
  final String? recentIp;
  final String? error;
  final String? lastSavedMovie;
  final String? lastSavedTvShow;

  const PlexState({
    required this.movieStatus,
    required this.tvShowStatus,
    required this.movies,
    required this.tvShow,
    required this.recentIp,
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
        error = null,
        lastSavedMovie = null,
        lastSavedTvShow = null;

  PlexState copyWith({
    List<Movie>? movies,
    List<TvShow>? tvShow,
    PlexStatus? movieStatus,
    PlexStatus? tvShowStatus,
    String? recentIp,
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
