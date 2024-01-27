import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/media.dart';
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
