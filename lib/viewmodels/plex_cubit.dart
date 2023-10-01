import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
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
            recentIp: null,
          ),
        ) {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await getSavedMedia();
  }

  final PlexRepository _plexRepository;
  late SharedPreferences prefs;

  Future<void> getSavedMedia() async {
    final movies = prefs.getString('movies');
    final tvShows = prefs.getString('tv');
    List<Movie> extractedMovies = [];
    if (movies != null) {
      for (var movie in jsonDecode(movies)) {
        extractedMovies.add(Movie.fromJson(movie));
      }
    }

    List<TvShow> extractedTvShows = [];
    if (tvShows != null) {
      for (var tv in jsonDecode(tvShows)) {
        extractedTvShows.add(TvShow.fromJson(tv));
      }
    }
    extractedMovies.isEmpty && extractedTvShows.isEmpty
        ? emit(
            PlexState.error(
              error: 'No Media Saved',
            ),
          )
        : emit(
            PlexState.loaded(
              movies: extractedMovies,
              tvShow: extractedTvShows,
              recentIp: recentIp,
            ),
          );
  }

  String get recentIp => prefs.getString('recentIp') ?? "";

  void extractMedia(String ip) async {
    emit(
      PlexState.loadingMovies(
        movies: const [],
        tvShow: const [],
      ),
    );
    final movies = await _plexRepository.extractMovies(ip);
    emit(
      PlexState.loadingTvShows(
        movies: movies,
        tvShow: const [],
      ),
    );
    final tv = await _plexRepository.extractTvShows(ip);
    _save(movies, tv, ip);
    emit(
      PlexState.loaded(
        movies: movies,
        tvShow: tv,
        recentIp: recentIp,
      ),
    );
  }

  Future<void> _save(
      List<Movie> movies, List<TvShow> tvShows, String recentIp) async {
    final movieJson = jsonEncode(movies);
    final tvJson = jsonEncode(tvShows);
    await prefs.setString('movies', movieJson);
    await prefs.setString('tv', tvJson);
    await prefs.setString('lastSave', DateTime.now().toString());
    await prefs.setString('recentIp', recentIp);
  }
}
