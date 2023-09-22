import 'package:flutter/material.dart';
import 'package:plex_extractor_app/extensions/duration_extension.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_movie.dart';

class MovieRowItem extends StatelessWidget {
  const MovieRowItem({
    super.key,
    required this.movie,
  });

  final TvdbMovie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (movie.artworkPath != null)
          Image.network(
            movie.artworkPath!,
            width: 75,
            height: 120,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.name,
                style: style.copyWith(fontWeight: FontWeight.bold),
              ),
              if (movie.year != null)
                Text(
                  movie.year!,
                  style: style,
                ),
              if (movie.runTime != null)
                Text(
                  "${movie.runTime!.inMinutes} mins (${movie.runTime?.prettify})",
                  style: style,
                ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle get style => const TextStyle(fontSize: 20);
}
