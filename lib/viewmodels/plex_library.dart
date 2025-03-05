import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class PlexLibrary extends Equatable {
  final List<Media> medias;
  final String name;
  final String id;
  final PlexStatus status;

  final int total;
  final int count;
  final bool visible;

  const PlexLibrary({
    required this.name,
    required this.id,
    required this.medias,
    required this.status,
    this.total = 0,
    this.count = 0,
    this.visible = true,
  });

  PlexLibrary copyWith({
    String? name,
    String? id,
    List<Media>? items,
    PlexStatus? status,
    int? count,
    int? total,
    bool? visible,
  }) =>
      PlexLibrary(
        name: name ?? this.name,
        id: id ?? this.id,
        medias: items ?? medias,
        status: status ?? this.status,
        total: total ?? this.total,
        count: count ?? this.count,
        visible: visible ?? this.visible,
      );

  @override
  List<Object?> get props => [
        name,
        id,
        medias,
        status,
        total,
        count,
        visible,
      ];
}

extension FilterLibraryExtension on List<PlexLibrary> {
  List<PlexLibrary> filterByQuality(
      bool show4k, bool show1080, bool showOther) {
    List<PlexLibrary> filteredLibraries = map((library) {
      return library.copyWith(
        items: library.medias.filterByQuality(
          show4k: show4k,
          show1080: show1080,
          showOther: showOther,
        ),
      );
    }).toList();
    return filteredLibraries
        .where((library) => library.medias.isNotEmpty)
        .toList();
  }

  List<PlexLibrary> filterByName(String search) => map((library) {
        List<Media> filteredItems = library.medias
            .where((movie) =>
                movie.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
        return library.copyWith(
          items: filteredItems,
        );
      }).where((element) => element.medias.isNotEmpty).toList();
}
