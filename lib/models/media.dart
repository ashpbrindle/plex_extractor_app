abstract class Media {
  final String name;
  final String year;
  final String? artworkPath;

  Media({
    required this.name,
    required this.year,
    this.artworkPath,
  });
}
