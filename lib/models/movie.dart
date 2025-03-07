import 'package:plextractor/models/media.dart';

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

  @override
  Media? filterByQuality(
    bool show4k,
    bool show1080,
    bool showOther,
  ) {
    if ((show4k && resolution == "4k") ||
        (show1080 && resolution == "1080") ||
        (showOther && resolution != "4k" && resolution != "1080")) {
      return this;
    } else {
      return null;
    }
  }
}
