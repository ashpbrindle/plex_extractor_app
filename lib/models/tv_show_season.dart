part of tv_show;

class TvShowSeason {
  final List<TvShowEpisode> episodes;
  final String name;
  TvShowSeason({
    required this.name,
    required this.episodes,
  });
  factory TvShowSeason.fromJson(Map<String, dynamic> json) {
    List<TvShowEpisode> episodes = [];
    for (var tv in json["episodes"]) {
      episodes.add(TvShowEpisode.fromJson(tv));
    }
    return TvShowSeason(
      name: json["name"],
      episodes: episodes,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "episodes": episodes,
      };
}
