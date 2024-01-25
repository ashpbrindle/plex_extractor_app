import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/tv/tv_row_item.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class TvView extends StatelessWidget {
  const TvView({
    super.key,
    required this.tvShows,
    required this.status,
    required this.lastSavedDate,
  });

  final List<TvShow> tvShows;
  final PlexStatus status;
  final String? lastSavedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: Column(
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
                  const Text("TV Shows"),
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
                        "${tvShows.length}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blueGrey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text(
                        lastSavedDate != null ? "$lastSavedDate" : "N/A",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
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
            if (tvShows.isNotEmpty)
              ...tvShows
                  .map(
                    (e) => TvRowItem(tvShow: e),
                  )
                  .toList(),
          ],
        ),
        if (status == PlexStatus.loading)
          LinearProgressIndicator(
            color: Colors.orange,
            backgroundColor: Colors.orange.withOpacity(0.3),
          )
      ],
    );
  }
}
