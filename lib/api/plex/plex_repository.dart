library plex;

import 'package:http/http.dart' as http;
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:xml/xml.dart';

part 'plex_api.dart';

class PlexRepository {
  final plex = _PlexApi();
  Map<String, String> libraries = {};

  Future<void> init() async {
    libraries = await plex.libraries;
  }

  Future<List<Movie>> extractMovies() async {
    if (libraries.isEmpty) await init();
    List<Movie> movies = [];
    final key = libraries.keys.firstWhere(
      (key) => libraries[key]!.contains("movie"),
    );
    final path = libraries[key];
    if (path != null) {
      print("Extracting $path...");
      movies = (await plex.getMovies(key, path))
          .map((movieName) => Movie(
                name: movieName,
              ))
          .toList();
      print("Found ${movies.length} Movies!");
    } else {
      print("Path name \"$path\" is Invalid, skipping...");
    }

    return movies;
  }

  Future<List<TvShow>> extractTvShows() async {
    if (libraries.isEmpty) await init();
    Map<String, String> shows = {};
    for (final key in libraries.keys.where(
      (key) => libraries[key]!.contains("tv"),
    )) {
      final path = libraries[key];
      if (path != null) {
        print("Extracting $path...");
        shows = await plex.getTvShows(key, path);
        print("Found ${shows.length} TV Shows!");
      } else {
        print("Path name \"$path\" is Invalid, skipping...");
      }
    }
    return extractTvShowsSeasons(shows);
  }

  Future<List<TvShow>> extractTvShowsSeasons(Map<String, String> shows) async {
    Map<String, List<String>> extractedTvShows = {};
    for (final showId in shows.keys) {
      final showTitle = shows[showId];
      print("Extracting Seasons for $showTitle...");
      final seasons = await plex.getTvShowSeasons(showId);
      print("Found ${seasons.length} seasons for $showTitle...");
      extractedTvShows.putIfAbsent(showTitle ?? "Unknown", () => seasons);
    }
    List<TvShow> tvShows = [];
    extractedTvShows.entries.map((entry) => TvShow(
          name: entry.key,
        ));

    return tvShows;
  }
}
