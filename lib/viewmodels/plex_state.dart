import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';

class PlexState extends Equatable {
  final PlexStatus status;
  final List<Movie> movies;
  final List<TvShow> tvShow;
  final String? error;

  const PlexState({
    required this.status,
    required this.movies,
    required this.tvShow,
    this.error,
  });

  PlexState.init()
      : status = PlexStatus.init,
        movies = [],
        tvShow = [],
        error = null;
  PlexState.loading()
      : status = PlexStatus.loading,
        movies = [],
        tvShow = [],
        error = null;

  const PlexState.loaded({
    required this.movies,
    required this.tvShow,
  })  : status = PlexStatus.loaded,
        error = null;

  PlexState.error({
    required this.error,
  })  : status = PlexStatus.error,
        movies = [],
        tvShow = [];

  @override
  List<Object?> get props => [status, movies, error];
}

enum PlexStatus {
  init,
  loading,
  loaded,
  error;
}
