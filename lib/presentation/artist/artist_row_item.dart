import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/artist.dart';
import 'package:plex_extractor_app/style.dart';

class ArtistRowItem extends StatelessWidget {
  const ArtistRowItem({
    super.key,
    required this.artist,
  });

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artist.name,
            style: style.copyWith(fontWeight: FontWeight.bold),
          ),
          if (artist.year.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              artist.year,
              style: style,
            ),
          ],
          const SizedBox(height: 8),
          ...artist.albums.map(
            (album) => Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
              child: Text(
                album,
                style: style.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 