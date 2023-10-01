part of tv_show;

class TvShowSeason extends Media {
  List<TvShowEpisode> episodes;
  TvShowSeason({
    required super.name,
    required this.episodes,
    super.artworkPath,
  });
  factory TvShowSeason.fromJson(Map<String, dynamic> json) {
    List<TvShowEpisode> episodes = [];
    for (var tv in json["episodes"]) {
      episodes.add(TvShowEpisode.fromJson(tv));
    }
    return TvShowSeason(
      name: json["name"],
      artworkPath: json["path"],
      episodes: episodes,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": artworkPath,
        "episodes": episodes,
      };
}
