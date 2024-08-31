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
      year: json["year"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "seasons": seasons,
        "year": year,
      };

  @override
  TvShow? filterByQuality(
    bool show4k,
    bool show1080,
    bool showOther,
  ) {
    if (seasons == null) return this;
    List<TvShowSeason> newSeasons = [];
    for (final season in seasons!) {
      List<TvShowEpisode> newEpisodes = [];
      for (final episode in season.episodes) {
        if ((show4k && episode.resolution == "4k") ||
            (show1080 && episode.resolution == "1080") ||
            (showOther &&
                episode.resolution != "4k" &&
                episode.resolution != "1080")) {
          newEpisodes.add(episode);
        }
      }
      if (newEpisodes.isNotEmpty) {
        newSeasons.add(
          TvShowSeason(
            name: season.name,
            episodes: newEpisodes,
          ),
        );
      }
    }
    if (newSeasons.isEmpty) return null;
    return TvShow(
      name: name,
      year: year,
      type: type,
      seasons: newSeasons,
    );
  }
}
