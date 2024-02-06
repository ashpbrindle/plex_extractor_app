import 'dart:convert';
import 'package:plex_extractor_app/api/plex/plex_api.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexRepository {
  PlexRepository({
    required this.api,
    required this.sharedPreferences,
  });

  final PlexApi api;
  final Future<SharedPreferences> sharedPreferences;

  Future<List<Media>> getMedia(
    String ip,
    int port, {
    required PlexLibrary media,
  }) {
    return api.getMedia(media, ip, port);
  }

  Future<Map<String, String>> getLibraries(String ip, int port) async =>
      api.getLibraries(ip);

  Future<void> saveMedia({
    required List<PlexLibrary> medias,
    required String recentIp,
    required int recentPort,
    String? lastSave,
  }) async {
    final SharedPreferences prefs = await sharedPreferences;
    String full = "";
    for (var media in medias) {
      if (full.isEmpty) {
        final json = jsonEncode(media.items);
        full = "${media.name},$json";
      } else {
        full = "$full;${media.name},${jsonEncode(media.items)}";
      }
    }
    if (lastSave != null) await prefs.setString(SavedValues.date.key, lastSave);
    await prefs.setString(SavedValues.media.key, full);
    await prefs.setString(SavedValues.ip.key, recentIp);
    await prefs.setInt(SavedValues.port.key, recentPort);
  }

  Future<(List<PlexLibrary> media, String? save)> retrieveSavedMedia() async {
    final SharedPreferences prefs = await sharedPreferences;
    final medias = prefs.getString(SavedValues.media.key)?.split(";");
    final lastSave = prefs.getString(SavedValues.date.key);
    Map<String, List<Media>> extractedMedia = {};
    if (medias != null) {
      for (final media in medias) {
        List<Movie> extractedMovies = [];
        List<TvShow> extractedTv = [];
        final temp = media.split(",");
        final name = temp.first;
        final listOfMedias = temp.sublist(1).join(",");
        if (listOfMedias.contains('"type":"movie"')) {
          final movies = jsonDecode(listOfMedias);
          for (var movie in movies) {
            extractedMovies.add(Movie.fromJson(movie));
          }
          extractedMedia.putIfAbsent(name, () => extractedMovies);
        } else if (listOfMedias.contains('"type":"tvShow"')) {
          final shows = jsonDecode(listOfMedias);
          for (var show in shows) {
            extractedTv.add(TvShow.fromJson(show));
          }
          extractedMedia.putIfAbsent(name, () => extractedTv);
        } else {
          extractedMedia.putIfAbsent(name, () => []);
        }
      }
    }
    return (
      extractedMedia.entries
          .map(
            (entry) => PlexLibrary(
              name: entry.key,
              id: "",
              items: entry.value,
              status: PlexStatus.loaded,
            ),
          )
          .toList(),
      lastSave
    );
  }
}

enum SavedValues {
  media("media"),
  date("lastSave"),
  ip("recentIp"),
  port("recentPort");

  const SavedValues(this.key);
  final String key;
}
