import 'package:plex_extractor_app/models/media.dart';

class Artist extends Media {
  Artist({
    required super.name,
    required super.year,
    required super.type,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json["name"],
        year: json["year"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "year": year,
        "type": type,
      };

  @override
  Media? filterByQuality(bool show4k, bool show1080, bool showOther) => this;
}
