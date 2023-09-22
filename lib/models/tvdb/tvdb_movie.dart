class TvdbMovie {
  final String name;
  final String? artworkPath;
  final String? year;
  final Duration? runTime;
  TvdbMovie({
    required this.name,
    this.artworkPath,
    this.year,
    this.runTime,
  });
}
