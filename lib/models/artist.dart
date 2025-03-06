import 'package:plex_extractor_app/models/media.dart';

class Artist extends Media {
  final List<String> albums;

  Artist({
    required super.name,
    required super.year,
    required super.type,
    required this.albums,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json["name"] ?? '',
        year: json["year"] ?? '',
        type: json["type"] ?? '',
        albums: List<String>.from(json["albums"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "year": year,
        "type": type,
        "albums": albums,
      };

  @override
  Media? filterByQuality(bool show4k, bool show1080, bool showOther) => this;
}
