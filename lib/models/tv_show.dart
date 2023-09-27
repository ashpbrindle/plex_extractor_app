library tv_show;

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
}
