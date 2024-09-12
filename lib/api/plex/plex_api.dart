import 'dart:convert';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'package:xml/xml.dart';

class PlexApi {
  // static const plexToken = "4uMqH75fXVvnEQ_yJZ6A";

  Future<String?> login({
    required String username,
    required String password,
    String? verificationCode,
  }) async {
    const String productName = "PlexExtractorApp";
    const String productVersion = "1.0";
    const String uuid = "02bf5696-b8bb-4fca-8aaa-5cd4b3bfff62";

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Plex-Client-Identifier': uuid,
      'X-Plex-Product': productName,
      'X-Plex-Version': productVersion,
    };

    final Map<String, dynamic> requestBody = {
      'user': {
        'login': username,
        'password': password,
        if (verificationCode != null && verificationCode.isNotEmpty)
          'verification_code': verificationCode,
      },
    };
    final String jsonBody = jsonEncode(requestBody);
    final Uri apiUrl = Uri.parse('https://plex.tv/users/sign_in.json');
    try {
      // Make the POST request
      final http.Response response = await http.post(
        apiUrl,
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final authToken = responseData['user']['authentication_token'];
        print('Successfully retrieved auth token: $authToken');
        return authToken;
      } else {
        print(
            'Failed to authenticate: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

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
    final videos = document.findAllElements('Video').toList();
    for (int i = 0; i < videos.length; i++) {
      final video = videos[i];
      updateStatus(libraryName: libraryId, total: videos.length, count: i + 1);
      final media = video.findAllElements('Media');
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      final resolution = media.first.attributes
          .firstWhereOrNull(
              (element) => element.name.local.contains("videoResolution"))
          ?.value;
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
    final directories = document.findAllElements('Directory').toList();
    for (int i = 0; i < directories.length; i++) {
      final directory = directories[i];
      updateStatus(
          libraryName: libraryId, total: directories.length, count: i + 1);
      final ratingKey = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.local.contains("ratingKey"),
          )
          .value;
      final title = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.local.contains("title"),
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
              (attribute) => attribute.name.local.contains("title"),
            )
            .value;
        final ratingKey = directory.attributes
            .firstWhere(
              (attribute) => attribute.name.local.contains("ratingKey"),
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

  void updateStatus({
    required String libraryName,
    required int total,
    required int count,
  }) {
    IsolateNameServer.lookupPortByName("libraryCountUpdate")
        ?.send("$libraryName,$total,$count");
  }
}
