part of tv_show;

class TvShowSeason extends Media {
  List<TvShowEpisode> episodes;
  TvShowSeason({
    required super.name,
    required this.episodes,
    super.artworkPath,
  });
}
