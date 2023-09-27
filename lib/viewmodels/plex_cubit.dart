import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(
          const PlexState(
            status: PlexStatus.init,
            movies: [],
            tvShow: [],
          ),
        ) {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await getMovies();
  }

  final PlexRepository _plexRepository;
  late SharedPreferences prefs;

  Future<void> getMovies() async {
    final movies = prefs.getString('movies');
    if (movies != null) {
      List<Movie> extractedMovies = [];
      for (var movie in jsonDecode(movies)) {
        extractedMovies.add(Movie.fromJson(movie));
      }
      emit(
        PlexState.loaded(
          movies: extractedMovies,
          tvShow: const [],
        ),
      );
    }
  }

  void retrieveMovies(String ip) async {
    emit(
      PlexState.loading(),
    );
    final movies = await _plexRepository.extractMovies(ip);
    final tv = await _plexRepository.extractTvShows(ip);
    _saveMovies(movies);
    emit(
      PlexState.loaded(
        movies: movies,
        tvShow: tv,
      ),
    );
  }

  Future<void> _saveMovies(List<Movie> movies) async {
    final json = jsonEncode(movies);
    await prefs.setString('movies', json);
    await prefs.setString('lastSave', DateTime.now().toString());
  }
}
