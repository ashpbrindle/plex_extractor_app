library plex;

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:xml/xml.dart';

part 'plex_api.dart';

class PlexRepository {
  final plex = _PlexApi();

  Future<List<Media>> getMedia(
    String ip,
    int port, {
    required PlexLibrary media,
  }) {
    return plex.getMedia(media, ip, port);
  }

  Future<Map<String, String>> getLibraries(String ip, int port) async =>
      plex.getLibraries(ip);
}
