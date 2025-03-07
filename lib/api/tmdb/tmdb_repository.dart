// library tmdb;

// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:plextractor/models/movie.dart';
// import 'package:plextractor/models/tv_show.dart';
// import 'package:plextractor/models/tvdb/tvdb_movie.dart';
// import 'package:plextractor/models/tvdb/tvdb_tv_show.dart';
// part 'tmdb_api.dart';

// class TmdbRepository {
//   final tvdb = _TmdbApi();

//   Future<List<TvdbMovie>> getMovies(List<Movie> movies) async {
//     List<TvdbMovie> tvdbMovies = [];
//     for (final movie in movies) {
//       final response = await tvdb.getMovie(movie);
//       if (response != null) {
//         print(response["poster_path"]);
//         tvdbMovies.add(
//           TvdbMovie(
//             name: response["title"],
//             artworkPath:
//                 "https://image.tmdb.org/t/p/w500/${response["poster_path"]}",
//             year: movie.year,
//             runTime: Duration(minutes: response["runtime"]),
//           ),
//         );
//       }
//     }
//     return tvdbMovies;
//   }

//   Future<List<TvdbTvShow>> getTvShows(List<TvShow> tvShows) async {
//     List<TvdbTvShow> tvdbTvShows = [];
//     for (final tvShow in tvShows) {
//       final response = await tvdb.getTvShow(tvShow);
//       if (response != null) {
//         tvdbTvShows.add(
//           TvdbTvShow(
//             name: response["name"],
//             artworkPath: response["image"],
//             startyear: response["firstAired"].toString().substring(0, 4),
//             endYear: response["lastAired"].toString().substring(0, 4),
//             seasons: tvShow.seasons?.map((e) => e.name).toList(),
//           ),
//         );
//       }
//     }
//     return tvdbTvShows;
//   }
// }
