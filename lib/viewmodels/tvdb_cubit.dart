import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/api/tvdb/tvdb_repository.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/sample.dart';
import 'package:plex_extractor_app/viewmodels/tvdb_state.dart';

class TvdbCubit extends Cubit<TvdbState> {
  TvdbCubit({
    required TvdbRepository tvdbRepository,
  })  : _tvdbRepository = tvdbRepository,
        super(
          const TvdbState(
            status: TvdbStatus.init,
          ),
        );

  final TvdbRepository _tvdbRepository;

  Future<void> getMedia(List<Movie> movies) async {
    emit(
      const TvdbState(
        status: TvdbStatus.loading,
      ),
    );
    emit(
      TvdbState.loaded(
        movies: await _tvdbRepository.getMovies(sampleMovies),
        tvShows: await _tvdbRepository.getTvShows(sampleTvShows),
      ),
    );
  }
}
