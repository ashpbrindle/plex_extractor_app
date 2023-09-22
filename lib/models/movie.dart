import 'package:plex_extractor_app/models/media.dart';

class Movie extends Media {
  Movie({
    required super.name,
    super.tvdb,
  });
}
