import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_movie.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_tv_show.dart';

class TvdbState extends Equatable {
  final TvdbStatus status;
  final List<TvdbMovie> movies;
  final List<TvdbTvShow> tvShows;
  final String? error;

  const TvdbState({
    required this.status,
    this.movies = const [],
    this.tvShows = const [],
    this.error,
  });

  const TvdbState.init()
      : movies = const [],
        tvShows = const [],
        status = TvdbStatus.init,
        error = null;

  const TvdbState.loaded({
    required this.movies,
    required this.tvShows,
  })  : status = TvdbStatus.loaded,
        error = null;

  const TvdbState.error({
    required this.error,
  })  : movies = const [],
        tvShows = const [],
        status = TvdbStatus.error;

  @override
  // TODO: implement props
  List<Object?> get props => [movies, tvShows, status, error];
}

enum TvdbStatus {
  init,
  loading,
  loaded,
  error;
}
