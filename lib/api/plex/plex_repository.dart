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

  Future<String?> get savedUsername => sharedPreferences
      .then((prefs) => prefs.getString(SavedValue.username.key));

  Future<List<Media>> getMedia(
    String ip,
    String port,
    String token, {
    required PlexLibrary media,
  }) {
    return api.getMedia(media, ip, port, token);
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    final token = await api.login(
      username: username,
      password: password,
    );
    if (token != null) {
      final SharedPreferences prefs = await sharedPreferences;
      await prefs.setString(SavedValue.username.key, username);
      await prefs.setString(SavedValue.token.key, token);
    }
    return token;
  }

  Future<void> logout() async {
    final prefs = await sharedPreferences;
    prefs.remove(SavedValue.token.key);
  }

  Future<Map<String, String>> getLibraries(
          String ip, String port, String token) async =>
      api.getLibraries(ip, port, token);

  Future<void> saveMedia({
    required List<PlexLibrary> medias,
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
    if (lastSave != null) await prefs.setString(SavedValue.date.key, lastSave);
    await prefs.setString(SavedValue.media.key, full);
  }

  Future<void> saveCredentials({
    required String recentIp,
    required String recentPort,
    required String recentToken,
  }) async {
    final SharedPreferences prefs = await sharedPreferences;
    await prefs.setString(SavedValue.ip.key, recentIp);
    await prefs.setString(SavedValue.port.key, recentPort);
    await prefs.setString(SavedValue.token.key, recentToken);
  }

  Future<(List<PlexLibrary> media, String? save)> retrieveSavedMedia() async {
    final SharedPreferences prefs = await sharedPreferences;
    final medias = prefs.getString(SavedValue.media.key)?.split(";");
    final lastSave = prefs.getString(SavedValue.date.key);
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

  Future<String?> get recentIp =>
      sharedPreferences.then((prefs) => prefs.getString(SavedValue.ip.key));
  Future<String?> get recentPort =>
      sharedPreferences.then((prefs) => prefs.getString(SavedValue.port.key));
  Future<String?> get recentToken =>
      sharedPreferences.then((prefs) => prefs.getString(SavedValue.token.key));
}

enum SavedValue {
  media("media"),
  username("username"),
  date("lastSave"),
  ip("recentIp"),
  port("recentPort"),
  token("token");

  const SavedValue(this.key);
  final String key;
}
