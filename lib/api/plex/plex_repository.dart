library plex;

import 'package:http/http.dart' as http;
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:xml/xml.dart';

part 'plex_api.dart';

class PlexRepository {
  final plex = _PlexApi();
  Map<String, String> libraries = {};

  Future<List<Movie>> extractMovies(String ip) async {
    if (libraries.isEmpty) libraries = await plex.getLibraries(ip);
    List<Movie> movies = [];
    final libraryId = libraries.keys.firstWhere(
      (key) => (libraries[key]!.toLowerCase().contains("movie") ||
          libraries[key]!.toLowerCase().contains("film")),
    );
    final path = libraries[libraryId];
    if (path != null) {
      print("Extracting $path...");
      var tempMovies = (await plex.getMovies(libraryId, ip));
      movies = tempMovies
          .map((movie) => Movie(
                name: movie["title"] ?? "",
                year: movie["year"] ?? "",
                artworkPath: movie["thumb"],
              ))
          .toList();
      print("Found ${movies.length} Movies!");
    } else {
      print("Path name \"$path\" is Invalid, skipping...");
    }

    return movies;
  }

  Future<List<TvShow>> extractTvShows(String ip) async {
    if (libraries.isEmpty) libraries = await plex.getLibraries(ip);
    List<TvShow> tvShows = [];
    final libraryId = libraries.keys.firstWhere(
      (key) => (libraries[key]!.toLowerCase().contains("tv")),
    );
    final path = libraries[libraryId];
    if (path != null) {
      print("Extracting $path...");
      var movies = (await plex.getTvShows(libraryId, ip));
      print("Found ${tvShows.length} Tv Shows!");
      return movies;
    } else {
      print("Path name \"$path\" is Invalid, skipping...");
    }

    return tvShows;
  }
}
