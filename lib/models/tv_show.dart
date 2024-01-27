library tv_show;

import 'package:plex_extractor_app/models/media.dart';

part 'tv_show_season.dart';
part 'tv_show_episode.dart';

class TvShow extends Media {
  final List<TvShowSeason>? seasons;
  TvShow({
    required super.name,
    this.seasons,
    required super.year,
    required super.type,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    List<TvShowSeason> seasons = [];
    for (var tv in json["seasons"]) {
      seasons.add(TvShowSeason.fromJson(tv));
    }
    return TvShow(
      name: json["name"],
      seasons: seasons,
      type: json["type"],
      year: '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "seasons": seasons,
      };
}
