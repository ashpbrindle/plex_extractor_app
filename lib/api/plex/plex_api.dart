import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:xml/xml.dart';

class PlexApi {
  // static const plexToken = "4uMqH75fXVvnEQ_yJZ6A";

  /// Returns a map of id's and their paths
  Future<Map<String, String>> getLibraries(
      String ipAddress, String port, String plexToken) async {
    //http://[ipAddresss]:[port]/library/sections/?X-Plex-Token=[PlexToken]
    Map<String, String> libraries = {};
    final url = Uri.parse(
        'http://$ipAddress:$port/library/sections/?X-Plex-Token=$plexToken');
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final directories = document.findAllElements('Directory');
    for (final directory in directories) {
      final key = directory.attributes
          .firstWhere((p0) => p0.name.local.contains("key"))
          .value;
      final value = directory.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      if (!libraries.keys.contains(key)) {
        libraries.putIfAbsent(key, () => value);
      }
    }
    return libraries;
  }

  Future<List<Media>> getMedia(
      PlexLibrary library, String ip, String port, String plexToken) async {
    final type = await _extractType(library.id, ip, port, plexToken);
    switch (type) {
      case "movie":
        return await getMovies(library.id, ip, port, plexToken);
      case "show":
        return await getTvShows(library.id, ip, port, plexToken);
    }
    return [];
  }

  // Future<Map<String, List<Media>>> getEverything(
  //     Map<String, String> libraries, String ipAddress, String port) async {
  //   Map<String, List<Media>> media = {};
  //   for (final library in libraries.entries) {
  //     getMedia(library, ipAddress, port);
  //   }
  //   return media;
  // }

  Future<String?> _extractType(
      String key, String ip, String port, String plexToken) async {
    final url = Uri.parse(
      'http://$ip:$port/library/sections/$key/all?X-Plex-Token=$plexToken&',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final mediaContainer = document.findAllElements('MediaContainer');
    String? viewGroup;
    for (var container in mediaContainer) {
      viewGroup = container.attributes
          .firstWhereOrNull((p0) => p0.name.local.contains("viewGroup"))
          ?.value;
      break;
    }
    return viewGroup;
  }

  Future<List<Movie>> getMovies(
      String libraryId, String ipAddress, String port, String plexToken) async {
    // http://[IP address]:32400/library/sections/[Movies Library ID]/all?X-Plex-Token=[PlexToken]&[Filter]
    List<Movie> movies = [];
    final url = Uri.parse(
      'http://$ipAddress:$port/library/sections/$libraryId/all?X-Plex-Token=$plexToken&',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final videos = document.findAllElements('Video');
    for (var video in videos) {
      final media = video.findAllElements('Media');
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      final resolution = media.first.attributes
          .firstWhereOrNull(
              (element) => element.name.local.contains("videoResolution"))
          ?.value;
      // final width = media.first.attributes
      //     .firstWhereOrNull((element) => element.name.local.contains("width"))
      //     ?.value;
      // final height = media.first.attributes
      //     .firstWhereOrNull((element) => element.name.local.contains("height"))
      //     ?.value;
      var year = video.attributes
          .firstWhere((p0) => p0.name.local.contains("year"))
          .value;
      movies.add(
        Movie(
          name: title,
          year: year,
          type: "movie",
          resolution: resolution,
        ),
      );
    }
    return movies;
  }

  Future<List<TvShow>> getTvShows(
      String libraryId, String ipAddress, String port, String plexToken) async {
    // http://[IP address]:32400/library/sections/[Movies Library ID]/all?X-Plex-Token=[PlexToken]&[Filter]
    List<TvShow> tvShows = [];
    final url = Uri.parse(
      'http://$ipAddress:$port/library/sections/$libraryId/all?X-Plex-Token=$plexToken&',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final directories = document.findAllElements('Directory');
    for (var directory in directories) {
      final ratingKey = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.toString().contains("ratingKey"),
          )
          .value;
      final title = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.toString().contains("title"),
          )
          .value;
      var year = directory.attributes
          .firstWhereOrNull((p0) => p0.name.local.contains("year"))
          ?.value;
      tvShows.add(
        TvShow(
          name: title,
          seasons:
              await _getTvShowSeasons(ratingKey, ipAddress, port, plexToken),
          year: year ?? 'Year Not Found',
          type: 'tvShow',
        ),
      );
    }
    return tvShows;
  }

  Future<List<TvShowSeason>> _getTvShowSeasons(
      String id, String ip, String port, String plexToken) async {
    List<TvShowSeason> seasons = [];
    final url = Uri.parse(
      'http://$ip:$port/library/metadata/$id/children?X-Plex-Token=$plexToken',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final directories = document.findAllElements('Directory');
    for (final directory in directories) {
      try {
        final name = directory.attributes
            .firstWhere(
              (attribute) => attribute.name.toString().contains("title"),
            )
            .value;
        final ratingKey = directory.attributes
            .firstWhere(
              (attribute) => attribute.name.toString().contains("ratingKey"),
            )
            .value;
        seasons.add(
          TvShowSeason(
            name: name,
            episodes: await _getTvShowEpisodes(ratingKey, ip, port, plexToken),
          ),
        );
      } catch (e) {}
    }
    return seasons;
  }

  Future<List<TvShowEpisode>> _getTvShowEpisodes(
    String id,
    String ip,
    String port,
    String plexToken,
  ) async {
    List<TvShowEpisode> episodes = [];
    final url = Uri.parse(
      'http://$ip:$port/library/metadata/$id/children?X-Plex-Token=$plexToken',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final videos = document.findAllElements('Video');
    for (var video in videos) {
      final media = video.findAllElements('Media');
      final resolution = media.first.attributes
          .firstWhereOrNull(
              (element) => element.name.local.contains("videoResolution"))
          ?.value;
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      episodes.add(
        TvShowEpisode(
          name: title,
          resolution: resolution,
        ),
      );
    }
    return episodes;
  }

  void updateStatus(String text) {
    IsolateNameServer.lookupPortByName("messages")?.send(text);
  }
}
