import 'package:plex_extractor_app/models/media.dart';

class Movie extends Media {
  String? resolution;
  Movie({
    required super.name,
    required super.year,
    required super.type,
    required this.resolution,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        name: json["name"],
        year: json["year"],
        type: json["type"],
        resolution: json["resolution"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "year": year,
        "type": type,
        "resolution": resolution,
      };
}
