import 'package:flutter/material.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.media,
    required this.complete,
  });

  final PlexLibrary media;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  media.status.statusWidget,
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      media.name,
                    ),
                  ),
                  if (media.status.isLoading)
                    Text("${media.count}/${media.total}"),
                  if (media.status.isLoaded) Text("${media.items.length}")
                ],
              ),
            ),
          ),
        ),
        if (media.total != 0 && !complete)
          LinearProgressIndicator(
            value: media.count / media.total,
            color: media.total == media.count ? Colors.green : Colors.purple,
            backgroundColor: const Color.fromARGB(255, 178, 193, 201),
          )
      ],
    );
  }
}

extension PlexStatusExtension on PlexStatus {
  bool get isLoaded => this == PlexStatus.loaded;
  bool get isLoading => this == PlexStatus.loading;

  Color get colour => switch (this) {
        PlexStatus.init || PlexStatus.loading => Colors.orange,
        PlexStatus.loaded => Colors.green,
        PlexStatus.error => Colors.red
      };

  Widget get statusWidget => switch (this) {
        PlexStatus.init => Icon(
            Icons.question_mark,
            size: 24,
            color: colour,
          ),
        PlexStatus.loading => SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colour,
            ),
          ),
        PlexStatus.loaded => Icon(
            Icons.check,
            size: 24,
            color: colour,
          ),
        PlexStatus.error => Icon(
            Icons.error,
            size: 24,
            color: colour,
          )
      };
}
