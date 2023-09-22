part of plex;

class _PlexApi {
  static const plexToken = "4uMqH75fXVvnEQ_yJZ6A";
  static const ipAddress = "mediaserver.local";

  /// Returns a map of id's and their paths
  Future<Map<String, String>> get libraries async {
    //http://[IP address]:32400/library/sections/?X-Plex-Token=[PlexToken]
    Map<String, String> libraries = {};
    final url = Uri.parse(
        'http://$ipAddress:32400/library/sections/?X-Plex-Token=$plexToken');
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    // print(document);
    final directories = document.findAllElements('Directory');
    for (final _ in directories) {
      final locations = document.findAllElements('Location');
      for (final location in locations) {
        final id = location.attributes.first.value;
        final value = location.attributes[1].value;
        if (!libraries.keys.contains(id)) {
          libraries.putIfAbsent(id, () => value);
        }
      }
    }
    print(libraries);
    return libraries;
  }

  Future<List<String>> getMovies(
    String libraryId,
    String path, {
    String? filter,
  }) async {
    // http://[IP address]:32400/library/sections/[Movies Library ID]/all?X-Plex-Token=[PlexToken]&[Filter]
    List<String> movies = [];
    final url = Uri.parse(
      'http://$ipAddress:32400/library/sections/$libraryId/all?X-Plex-Token=$plexToken&${filter ?? ""}',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final medias = document.findAllElements('Media');
    for (final _ in medias) {
      final parts = document.findAllElements('Part');
      for (final part in parts) {
        final file = part.attributes
            .firstWhere(
              (attribute) => attribute.name.toString().contains("file"),
            )
            .value
            .replaceAll(".mp4", "")
            .replaceAll(".mkv", "")
            .split("/")
            .last;
        if (file.isNotEmpty && !movies.contains(file)) {
          print(file);
          movies.add(file);
        }
      }
    }
    return movies;
  }

  Future<Map<String, String>> getTvShows(
    String libraryId,
    String path, {
    String? filter,
  }) async {
    // http: //[IP address]:32400/library/metadata/[TV Show ID]]/children?X-Plex-Token=[PlexToken]
    Map<String, String> tvShows = {};
    final url = Uri.parse(
      'http://$ipAddress:32400/library/sections/$libraryId/all?X-Plex-Token=$plexToken&${filter ?? ""}',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final directories = document.findAllElements('Directory');
    for (final directory in directories) {
      final id = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.toString().contains("ratingKey"),
          )
          .value;
      final value = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.toString().contains("title"),
          )
          .value;
      if (!tvShows.keys.contains(id)) {
        tvShows.putIfAbsent(id, () => value);
      }
    }
    return tvShows;
  }

  Future<List<String>> getTvShowSeasons(
    String id,
  ) async {
    // http://[IP address]:32400/library/metadata/[TV Show ID]]/children?X-Plex-Token=[PlexToken]
    List<String> seasons = [];
    final url = Uri.parse(
      'http://$ipAddress:32400/library/metadata/$id/children?X-Plex-Token=$plexToken',
    );
    final response = await http.get(url);
    final document = XmlDocument.parse(response.body);
    final directories = document.findAllElements('Directory');
    for (final directory in directories) {
      final season = directory.attributes
          .firstWhere(
            (attribute) => attribute.name.toString().contains("title"),
          )
          .value;
      seasons.add(season);
    }
    return seasons;
  }
}
