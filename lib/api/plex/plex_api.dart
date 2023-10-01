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
    // print(document);
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
    print(libraries);
    return libraries;
  }

  Future<List<Map<String, String>>> getMovies(
      String libraryId, String ipAddress) async {
    // http://[IP address]:32400/library/sections/[Movies Library ID]/all?X-Plex-Token=[PlexToken]&[Filter]
    List<Map<String, String>> movies = [];
    final url = Uri.parse(
      'http://$ipAddress:32400/library/sections/$libraryId/all?X-Plex-Token=$plexToken&',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final videos = document.findAllElements('Video');
    for (var video in videos) {
      var thumb = video.attributes
          .firstWhere((p0) => p0.name.local.contains("thumb"))
          .value;
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      var year = video.attributes
          .firstWhere((p0) => p0.name.local.contains("year"))
          .value;
      movies.add({
        "thumb": "http://$ipAddress:32400$thumb?X-Plex-Token=$plexToken",
        "title": title,
        "year": year,
      });
    }
    return movies;
  }

  Future<List<TvShow>> getTvShows(String libraryId, String ipAddress) async {
    // http://[IP address]:32400/library/sections/[Movies Library ID]/all?X-Plex-Token=[PlexToken]&[Filter]
    List<TvShow> tvShows = [];
    final url = Uri.parse(
      'http://$ipAddress:32400/library/sections/$libraryId/all?X-Plex-Token=$plexToken&',
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
      tvShows.add(
        TvShow(
          name: title,
          seasons: await _getTvShowSeasons(ratingKey, ipAddress),
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
      } catch (e) {
        print("Invalid Tv Show, Skipping...");
      }
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
      var thumb = video.attributes
          .firstWhere((p0) => p0.name.local.contains("thumb"))
          .value;
      var title = video.attributes
          .firstWhere((p0) => p0.name.local.contains("title"))
          .value;
      episodes.add(
        TvShowEpisode(
          name: title,
          artworkPath: "http://$ip:32400$thumb?X-Plex-Token=$plexToken",
        ),
      );
    }
    return episodes;
  }
}
