import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/models/media.dart';
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
    // final movies = prefs.getString('movies');
    // final tvShows = prefs.getString('tv');
    // final lastMovie = prefs.getString("lastSaveMovie");
    // final lastTv = prefs.getString("lastSaveTv");
    // List<Movie> extractedMovies = [];
    // if (movies != null) {
    //   for (var movie in jsonDecode(movies)) {
    //     extractedMovies.add(Movie.fromJson(movie));
    //   }
    // }
    // emit(
    //   state.copyWith(
    //     movies: extractedMovies,
    //     movieStatus: PlexStatus.loaded,
    //     error: null,
    //     lastSavedMovie: lastMovie,
    //     lastSavedTvShow: lastTv,
    //   ),
    // );

    // List<TvShow> extractedTvShows = [];
    // if (tvShows != null) {
    //   for (var tv in jsonDecode(tvShows)) {
    //     extractedTvShows.add(TvShow.fromJson(tv));
    //   }
    // }
    // emit(
    //   state.copyWith(
    //     tvShow: extractedTvShows,
    //     tvShowStatus: PlexStatus.loaded,
    //     error: null,
    //   ),
    // );

    // if (extractedMovies.isEmpty && extractedTvShows.isEmpty) {
    //   emit(
    //     state.copyWith(
    //       movies: [],
    //       tvShow: [],
    //       movieStatus: PlexStatus.error,
    //       tvShowStatus: PlexStatus.error,
    //       error: "Failed to fetch saved media. Please Connect",
    //     ),
    //   );
    // }
  }

  String get recentIp => prefs.getString('recentIp') ?? "";
  int? get recentPort => prefs.getInt('recentPort');

  void extractMedia(
    String ip,
    int port, {
    String? movie1Path,
    String? movie2Path,
    String? tv1Path,
    String? tv2Path,
  }) async {
    String? lastSuccessfulMovieDate;
    String? lastSuccessfulTvShowDate;
    emit(
      state.copyWith(
        recentIp: recentIp,
        recentPort: recentPort,
        error: null,
      ),
    );
    Map<String, List<Media>> media;
    String lastSuccessfulDate = "";
    try {
      media = await _plexRepository.extractEverything(ip, port);
      lastSuccessfulDate =
          DateFormat('dd/MM/yyyy HH:MM').format(DateTime.now());
      emit(
        state.copyWith(
          status: PlexStatus.loaded,
          media: media,
          lastSaved: lastSuccessfulMovieDate,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: PlexStatus.error,
            media: state.media,
            error: "Error Extracting Movies from Plex,\n $e"),
      );
    }
    // _save(movies ?? state.movies, tv ?? state.tvShow, ip, port,
    //     lastSuccessfulTvShowDate, lastSuccessfulMovieDate);
  }

  Future<void> _save(
    List<Movie> movies,
    List<TvShow> tvShows,
    String recentIp,
    int recentPort,
    String? lastTv,
    String? lastMovie,
  ) async {
    final movieJson = jsonEncode(movies);
    final tvJson = jsonEncode(tvShows);
    await prefs.setString('movies', movieJson);
    await prefs.setString('tv', tvJson);
    lastTv != null ? await prefs.setString('lastSaveTv', lastTv) : null;
    lastMovie != null
        ? await prefs.setString('lastSaveMovie', lastMovie)
        : null;
    await prefs.setString('recentIp', recentIp);
    await prefs.setInt('recentPort', recentPort);
  }
}
