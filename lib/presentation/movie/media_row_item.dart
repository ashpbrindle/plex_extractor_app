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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  media.name,
                  style: style.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
          if (media is Movie) Text("${(media as Movie).resolution}"),
        ],
      ),
    );
  }
}
