import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/presentation/movie/movie_row_item.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({
    super.key,
    required this.movies,
    required this.status,
    required this.lastSavedDate,
  });

  final List<Movie> movies;
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
                      const Text("Movies"),
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
                        "${movies.length}",
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
            if (movies.isNotEmpty)
              ...movies
                  .map(
                    (e) => MovieRowItem(movie: e),
                  )
                  .toList(),
          ],
        ),
        if (status == PlexStatus.loading)
          LinearProgressIndicator(
            color: Colors.orange,
            backgroundColor: Colors.orange.withOpacity(0.3),
          ),
      ],
    );
  }
}
