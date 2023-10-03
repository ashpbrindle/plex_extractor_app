import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexCubit extends Cubit<PlexState> {
  PlexCubit({
    required PlexRepository plexRepository,
  })  : _plexRepository = plexRepository,
        super(PlexState.init()) {
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
    final lastMovie = prefs.getString("lastSaveMovie");
    final lastTv = prefs.getString("lastSaveTv");
    List<Movie> extractedMovies = [];
    if (movies != null) {
      for (var movie in jsonDecode(movies)) {
        extractedMovies.add(Movie.fromJson(movie));
      }
    }
    emit(
      state.copyWith(
        movies: extractedMovies,
        movieStatus: PlexStatus.loaded,
        error: null,
        lastSavedMovie: lastMovie,
        lastSavedTvShow: lastTv,
      ),
    );

    List<TvShow> extractedTvShows = [];
    if (tvShows != null) {
      for (var tv in jsonDecode(tvShows)) {
        extractedTvShows.add(TvShow.fromJson(tv));
      }
    }
    emit(
      state.copyWith(
        tvShow: extractedTvShows,
        tvShowStatus: PlexStatus.loaded,
        error: null,
      ),
    );

    if (extractedMovies.isEmpty && extractedTvShows.isEmpty) {
      emit(
        state.copyWith(
          movies: [],
          tvShow: [],
          movieStatus: PlexStatus.error,
          tvShowStatus: PlexStatus.error,
          error: "Failed to fetch media",
        ),
      );
    }
  }

  String get recentIp => prefs.getString('recentIp') ?? "";

  void extractMedia(String ip) async {
    DateTime? lastSuccessfulMovieDate;
    DateTime? lastSuccessfulTvShowDate;
    emit(
      state.copyWith(
        recentIp: recentIp,
        movieStatus: PlexStatus.loading,
        tvShowStatus: PlexStatus.loading,
        error: null,
      ),
    );
    List<Movie>? movies;
    try {
      movies = await _plexRepository.extractMovies(ip);
      lastSuccessfulMovieDate = DateTime.now();
      emit(
        state.copyWith(
          movieStatus: PlexStatus.loaded,
          movies: movies,
          lastSavedMovie:
              DateFormat('dd/MM/yyyy HH:mm').format(lastSuccessfulMovieDate),
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            movieStatus: PlexStatus.error,
            movies: state.movies,
            error: "Error Extracting Movies from Plex"),
      );
      print(e);
    }
    List<TvShow>? tv;
    try {
      tv = await _plexRepository.extractTvShows(ip);
      lastSuccessfulTvShowDate = DateTime.now();
      emit(
        state.copyWith(
          tvShowStatus: PlexStatus.loaded,
          lastSavedTvShow:
              DateFormat('dd/MM/yyyy HH:mm').format(lastSuccessfulTvShowDate),
          tvShow: tv,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            tvShowStatus: PlexStatus.error,
            tvShow: state.tvShow,
            error: "Error Extracting TV Shows from Plex"),
      );
      print(e);
    }
    _save(movies ?? state.movies, tv ?? state.tvShow, ip,
        lastSuccessfulTvShowDate, lastSuccessfulMovieDate);
  }

  Future<void> _save(
    List<Movie> movies,
    List<TvShow> tvShows,
    String recentIp,
    DateTime? lastTv,
    DateTime? lastMovie,
  ) async {
    final movieJson = jsonEncode(movies);
    final tvJson = jsonEncode(tvShows);
    await prefs.setString('movies', movieJson);
    await prefs.setString('tv', tvJson);
    lastTv != null
        ? await prefs.setString('lastSaveTv', lastTv.toString())
        : null;
    lastMovie != null
        ? await prefs.setString('lastSaveMovie', lastMovie.toString())
        : null;
    await prefs.setString('recentIp', recentIp);
  }
}
