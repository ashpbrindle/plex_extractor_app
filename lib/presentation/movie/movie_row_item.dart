import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/style.dart';

class MediaRowItem extends StatelessWidget {
  const MediaRowItem({
    super.key,
    required this.media,
    this.showArtwork = false,
  });

  final Media media;
  final bool showArtwork;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (media.artworkPath != null && showArtwork)
          CachedNetworkImage(
            maxHeightDiskCache: 120,
            maxWidthDiskCache: 50,
            imageUrl: media.artworkPath!,
            progressIndicatorBuilder: (context, url, progress) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: 75,
            height: 120,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  media.name,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  media.year,
                  style: style,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
