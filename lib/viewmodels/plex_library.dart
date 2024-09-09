import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class PlexLibrary extends Equatable {
  List<Media> items;
  final String name;
  final String id;
  final PlexStatus status;
  final int total;
  final int count;

  PlexLibrary({
    required this.name,
    required this.id,
    required this.items,
    required this.status,
    this.total = 0,
    this.count = 0,
  });

  PlexLibrary copyWith({
    String? name,
    String? id,
    List<Media>? items,
    PlexStatus? status,
    int? count,
    int? total,
  }) =>
      PlexLibrary(
        name: name ?? this.name,
        id: id ?? this.id,
        items: items ?? this.items,
        status: status ?? this.status,
        total: total ?? this.total,
        count: count ?? this.count,
      );

  @override
  List<Object?> get props => [name, id, items, status, total, count];
}

extension FilterLibraryExtension on List<PlexLibrary> {
  List<PlexLibrary> filterByQuality(
      bool show4k, bool show1080, bool showOther) {
    List<PlexLibrary> filteredLibraries = map((library) {
      return PlexLibrary(
        items: library.items.filterByQuality(
            show4k: show4k, show1080: show1080, showOther: showOther),
        name: library.name,
        id: library.id,
        status: library.status,
      );
    }).toList();
    return filteredLibraries
        .where((library) => library.items.isNotEmpty)
        .toList();
  }

  List<PlexLibrary> filterByName(String search) => map((library) {
        List<Media> filteredItems = library.items
            .where((movie) =>
                movie.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
        return PlexLibrary(
            name: library.name,
            id: library.id,
            items: filteredItems,
            status: library.status);
      }).where((element) => element.items.isNotEmpty).toList();
}
