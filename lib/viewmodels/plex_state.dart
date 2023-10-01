import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';

class PlexState extends Equatable {
  final PlexStatus status;
  final List<Movie> movies;
  final List<TvShow> tvShow;
  final String? recentIp;
  final String? error;

  const PlexState({
    required this.status,
    required this.movies,
    required this.tvShow,
    required this.recentIp,
    this.error,
  });

  PlexState.init()
      : status = PlexStatus.init,
        movies = [],
        tvShow = [],
        recentIp = null,
        error = null;
  PlexState.loadingMovies({
    required List<Movie>? movies,
    required List<TvShow>? tvShow,
  })  : status = PlexStatus.loadingMovies,
        movies = movies ?? [],
        tvShow = tvShow ?? [],
        recentIp = null,
        error = null;

  PlexState.loadingTvShows({
    required List<Movie>? movies,
    required List<TvShow>? tvShow,
  })  : status = PlexStatus.loadingTvShows,
        movies = movies ?? [],
        tvShow = tvShow ?? [],
        recentIp = null,
        error = null;

  const PlexState.loaded({
    required this.movies,
    required this.tvShow,
    required this.recentIp,
  })  : status = PlexStatus.loaded,
        error = null;

  PlexState.error({
    required this.error,
  })  : status = PlexStatus.error,
        recentIp = null,
        movies = [],
        tvShow = [];

  @override
  List<Object?> get props => [status, movies, error];
}

enum PlexStatus {
  init,
  loadingMovies,
  loadingTvShows,
  loaded,
  error;

  String getStatus([String? error]) => switch (this) {
        PlexStatus.loadingMovies => "Loading Movies...",
        PlexStatus.loadingTvShows => "Loading Tv Shows...",
        _ => "Refresh Library"
      };
}
