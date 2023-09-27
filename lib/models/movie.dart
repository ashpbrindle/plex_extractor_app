import 'package:plex_extractor_app/models/media.dart';

class Movie extends Media {
  final String year;
  Movie({
    required super.name,
    required this.year,
    required super.artworkPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        name: json["name"],
        artworkPath: json["path"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": artworkPath,
        "year": year,
      };
}
