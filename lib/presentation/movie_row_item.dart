import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/movie.dart';

class MovieRowItem extends StatelessWidget {
  const MovieRowItem({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if (movie.artworkPath != null)
        // CachedNetworkImage(
        //   imageUrl: movie.artworkPath!,
        //   placeholder: (context, url) =>
        //       const Center(child: CircularProgressIndicator()),
        //   errorWidget: (context, url, error) => const Icon(Icons.error),
        //   width: 75,
        //   height: 120,
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  movie.name,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  movie.year,
                  style: style,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle get style => const TextStyle(fontSize: 20);
}
