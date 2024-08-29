import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class PlexLibrary extends Equatable {
  List<Media> items;
  final String name;
  final String id;
  final PlexStatus status;

  PlexLibrary({
    required this.name,
    required this.id,
    required this.items,
    required this.status,
  });

  PlexLibrary copyWith({
    String? name,
    String? id,
    List<Media>? items,
    PlexStatus? status,
  }) =>
      PlexLibrary(
        name: name ?? this.name,
        id: id ?? this.id,
        items: items ?? this.items,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [name, id, items, status];
}
