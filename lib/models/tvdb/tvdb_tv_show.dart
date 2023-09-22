class TvdbTvShow {
  final String name;
  final String? artworkPath;
  final String? startyear;
  final String? endYear;
  final List<String>? seasons;
  TvdbTvShow({
    required this.name,
    this.artworkPath,
    this.startyear,
    this.endYear,
    this.seasons,
  });
}
