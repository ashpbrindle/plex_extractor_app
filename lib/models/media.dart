abstract class Media {
  final String name;
  final String year;
  final String type;

  Media({
    required this.name,
    required this.year,
    required this.type,
  });

  Media? filterByQuality(
    bool show4k,
    bool show1080,
    bool showOther,
  );
}

extension MediaFilter on List<Media> {
  List<Media> filterByQuality({
    required bool show4k,
    required bool show1080,
    required bool showOther,
  }) {
    List<Media> newMedias = [];
    for (final media in this) {
      final newMedia = media.filterByQuality(show4k, show1080, showOther);
      if (newMedia != null) {
        newMedias.add(newMedia);
      }
    }
    return newMedias;
  }
}
