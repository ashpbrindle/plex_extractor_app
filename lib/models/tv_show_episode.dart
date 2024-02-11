part of tv_show;

class TvShowEpisode {
  final String name;
  final String? resolution;
  TvShowEpisode({
    required this.name,
    required this.resolution,
  });

  factory TvShowEpisode.fromJson(Map<String, dynamic> json) => TvShowEpisode(
        name: json["name"],
        resolution: json["resolution"],
      );

  Map<String, dynamic> toJson() => {"name": name, "resolution": resolution};
}
