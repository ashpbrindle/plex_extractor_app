part of tv_show;

class TvShowEpisode {
  final String name;
  TvShowEpisode(this.name);

  factory TvShowEpisode.fromJson(Map<String, dynamic> json) => TvShowEpisode(
        json["name"],
      );

  Map<String, dynamic> toJson() => {"name": name};
}
