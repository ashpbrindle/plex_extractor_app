import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/tv/tv_season_item.dart';
import 'package:plex_extractor_app/style.dart';

class TvRowItem extends StatelessWidget {
  const TvRowItem({
    super.key,
    required this.tvShow,
  });

  final TvShow tvShow;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          if (tvShow.artworkPath != null)
            CachedNetworkImage(
              imageUrl: tvShow.artworkPath!,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 75,
              height: 120,
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Text(
              tvShow.name,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      children: (tvShow.seasons ?? [])
          .map(
            (season) => TvSeasonItem(season: season),
          )
          .toList(),
    );
  }
}
