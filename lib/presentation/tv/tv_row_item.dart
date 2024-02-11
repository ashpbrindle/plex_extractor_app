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
      title: Text(
        tvShow.name,
        style: style.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        tvShow.year,
        style: style,
      ),
      children: (tvShow.seasons ?? [])
          .map(
            (season) => TvSeasonItem(season: season),
          )
          .toList(),
    );
  }
}
