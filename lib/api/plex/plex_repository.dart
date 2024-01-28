library plex;

import 'dart:ui';

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
}
