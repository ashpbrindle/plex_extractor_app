import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(
          const PlexState(
            status: PlexStatus.init,
          ),
        );

  final PlexRepository _plexRepository;

  Future<List<Movie>> get movies async {
    return await _plexRepository.extractMovies();
  }
}
