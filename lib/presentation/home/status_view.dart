import 'package:flutter/material.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.media,
  });

  final PlexLibrary media;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: media.status.colour,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Center(
        child: Text(
          media.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

extension PlexStatusExtension on PlexStatus {
  Color get colour => switch (this) {
        PlexStatus.init || PlexStatus.loading => Colors.orange,
        PlexStatus.loaded => Colors.green,
        PlexStatus.error => Colors.red
      };
}
