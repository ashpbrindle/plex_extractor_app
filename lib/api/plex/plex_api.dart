part of plex;

class _PlexApi {
  static const plexToken = "4uMqH75fXVvnEQ_yJZ6A";

  /// Returns a map of id's and their paths
  Future<Map<String, String>> getLibraries(String ipAddress) async {
    //http://[IP address]:32400/library/sections/?X-Plex-Token=[PlexToken]
    Map<String, String> libraries = {};
    final url = Uri.parse(
        'http://$ipAddress:32400/library/sections/?X-Plex-Token=$plexToken');
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    // log.debug('...');(document);
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

  Future<List<Media>> getMedia(PlexLibrary library, String ip, int port) async {
    final type = await _extractType(library.id, ip, port);
    switch (type) {
      case "movie":
        return await getMovies(library.id, ip, port);
      case "show":
        return await getTvShows(library.id, ip, port);
    }
    return [];
  }

  // Future<Map<String, List<Media>>> getEverything(
  //     Map<String, String> libraries, String ipAddress, int port) async {
  //   Map<String, List<Media>> media = {};
  //   for (final library in libraries.entries) {
  //     getMedia(library, ipAddress, port);
  //   }
  //   return media;
  // }

  Future<String?> _extractType(String key, String ip, int port) async {
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
      if (viewGroup != null) break;
    }
    return viewGroup;
  }

  Future<List<Movie>> getMovies(
      String libraryId, String ipAddress, int port) async {
    // http://[IP address]:32400/library/sections/[Movies Library ID]/all?X-Plex-Token=[PlexToken]&[Filter]
    List<Movie> movies = [];
    final url = Uri.parse(
      'http://$ipAddress:$port/library/sections/$libraryId/all?X-Plex-Token=$plexToken&',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final videos = document.findAllElements('Video');
    for (var video in videos) {
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      var year = video.attributes
          .firstWhere((p0) => p0.name.local.contains("year"))
          .value;
      movies.add(
        Movie(
          name: title,
          year: year,
          type: "movie",
        ),
      );
    }
    return movies;
  }

  Future<List<TvShow>> getTvShows(
      String libraryId, String ipAddress, int port) async {
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
          seasons: await _getTvShowSeasons(ratingKey, ipAddress),
          year: year ?? 'Year Not Found',
          type: 'tvShow',
        ),
      );
    }
    return tvShows;
  }

  Future<List<TvShowSeason>> _getTvShowSeasons(
    String id,
    String ip,
  ) async {
    List<TvShowSeason> seasons = [];
    final url = Uri.parse(
      'http://$ip:32400/library/metadata/$id/children?X-Plex-Token=$plexToken',
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
            episodes: await _getTvShowEpisodes(ratingKey, ip),
          ),
        );
      } catch (e) {}
    }
    return seasons;
  }

  Future<List<TvShowEpisode>> _getTvShowEpisodes(
    String id,
    String ip,
  ) async {
    List<TvShowEpisode> episodes = [];
    final url = Uri.parse(
      'http://$ip:32400/library/metadata/$id/children?X-Plex-Token=$plexToken',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final videos = document.findAllElements('Video');
    for (var video in videos) {
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      episodes.add(
        TvShowEpisode(title),
      );
    }
    return episodes;
  }

  void updateStatus(String text) {
    IsolateNameServer.lookupPortByName("messages")?.send(text);
  }
}
