library tv_show;

import 'dart:convert';

import 'package:plex_extractor_app/models/media.dart';

part 'tv_show_season.dart';
part 'tv_show_episode.dart';

class TvShow extends Media {
  final List<TvShowSeason>? seasons;
  TvShow({
    required super.name,
    super.artworkPath,
    this.seasons,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    List<TvShowSeason> seasons = [];
    for (var tv in json["seasons"]) {
      seasons.add(TvShowSeason.fromJson(tv));
    }
    return TvShow(
      name: json["name"],
      artworkPath: json["path"],
      seasons: seasons,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": artworkPath,
        "seasons": seasons,
      };
}
