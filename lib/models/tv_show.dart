library tv_show;

import 'package:plex_extractor_app/models/media.dart';

part 'tv_show_season.dart';

class TvShow extends Media {
  List<TvShowSeason>? seasons;
  TvShow({
    required super.name,
    super.tvdb,
    Map<String, String>? seasonsNames, // name/tvdb
  }) {
    if (seasonsNames != null) {
      updateSeasons(seasonsNames);
    }
  }

  void updateSeasons(Map<String, String> seasonsNames) {
    seasons = seasonsNames.entries
        .map(
          (entry) => TvShowSeason(name: entry.key, tvdb: entry.value),
        )
        .toList();
  }
}
