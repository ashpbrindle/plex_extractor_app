import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/presentation/movie/movie_row_item.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class MediaView extends StatelessWidget {
  const MediaView({
    super.key,
    required this.name,
    required this.media,
    required this.status,
  });

  final String name;
  final List<Media> media;
  final PlexStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) => switch (status) {
                          PlexStatus.init => Container(),
                          PlexStatus.loading => const Icon(
                              Icons.download,
                              color: Colors.grey,
                            ),
                          PlexStatus.error => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          PlexStatus.loaded => const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(name),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 14, 25, 74),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text(
                        "${media.length}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          children: [
            if (media.isNotEmpty)
              ...media
                  .map(
                    (e) => MediaRowItem(media: e),
                  )
                  .toList(),
          ],
        ),
        // if (status == PlexStatus.loading)
        //   LinearProgressIndicator(
        //     color: Colors.orange,
        //     backgroundColor: Colors.orange.withOpacity(0.3),
        //   ),
      ],
    );
  }
}
