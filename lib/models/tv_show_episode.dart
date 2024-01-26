part of tv_show;

class TvShowEpisode extends Media {
  TvShowEpisode({
    required super.name,
    required super.artworkPath,
    required super.year,
  });

  factory TvShowEpisode.fromJson(Map<String, dynamic> json) => TvShowEpisode(
        name: json["name"],
        artworkPath: json["path"],
        year: '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": artworkPath,
      };
}
