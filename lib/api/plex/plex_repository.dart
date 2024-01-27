library plex;

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:xml/xml.dart';

part 'plex_api.dart';

class PlexRepository {
  final plex = _PlexApi();

  Future<Map<String, List<Media>>> extractEverything(
      String ip, int port) async {
    final libraries = await plex.getLibraries(ip);
    // {Library, List<Media>}
    return plex.getEverything(libraries, ip, port);
  }

  Future<List<Movie>> extractMovies(
    String ip,
    int port, {
    String? movieFolder,
  }) async {
    final libraries = await plex.getLibraries(ip);
    List<Movie> movies = [];
    final libraryId = libraries.keys.firstWhere(
      (key) =>
          (libraries[key]!.toLowerCase().contains(movieFolder ?? "movie") ||
              libraries[key]!.toLowerCase().contains(movieFolder ?? "film")),
    );
    final path = libraries[libraryId];
    if (path != null) {
      print("Extracting $path...");
      movies = (await plex.getMovies(libraryId, ip, port));
      print("Found ${movies.length} Movies!");
    } else {
      print("Path name \"$path\" is Invalid, skipping...");
    }

    return movies;
  }

  Future<List<TvShow>> extractTvShows(
    String ip,
    int port, {
    String? tvFolder,
  }) async {
    final libraries = await plex.getLibraries(ip);
    List<TvShow> tvShows = [];
    final libraryId = libraries.keys.firstWhere(
      (key) => (libraries[key]!.toLowerCase().contains(tvFolder ?? "tv")),
    );
    final path = libraries[libraryId];
    if (path != null) {
      print("Extracting $path...");
      var tvShows = (await plex.getTvShows(libraryId, ip, port));
      print("Found ${tvShows.length} Tv Shows!");
      return tvShows;
    } else {
      print("Path name \"$path\" is Invalid, skipping...");
    }

    return tvShows;
  }
}
