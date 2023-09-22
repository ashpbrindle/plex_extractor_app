library tvdb;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_movie.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_tv_show.dart';
part 'tvdb_api.dart';

class TvdbRepository {
  final tvdb = _TvdbApi();

  Future<List<TvdbMovie>> getMovies(List<Movie> movies) async {
    List<TvdbMovie> tvdbMovies = [];
    for (final movie in movies) {
      final response = await tvdb.getMovie(movie);
      if (response != null) {
        tvdbMovies.add(
          TvdbMovie(
            name: response["name"],
            artworkPath: response["image"],
            year: response["year"],
            runTime: Duration(minutes: response["runtime"]),
          ),
        );
      }
    }
    return tvdbMovies;
  }

  Future<List<TvdbTvShow>> getTvShows(List<TvShow> tvShows) async {
    List<TvdbTvShow> tvdbTvShows = [];
    for (final tvShow in tvShows) {
      final response = await tvdb.getTvShow(tvShow);
      if (response != null) {
        tvdbTvShows.add(
          TvdbTvShow(
            name: response["name"],
            artworkPath: response["image"],
            startyear: response["firstAired"].toString().substring(0, 4),
            endYear: response["lastAired"].toString().substring(0, 4),
            seasons: tvShow.seasons?.map((e) => e.name).toList(),
          ),
        );
      }
    }
    return tvdbTvShows;
  }
}
