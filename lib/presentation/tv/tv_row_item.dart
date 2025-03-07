import 'package:flutter/material.dart';
import 'package:plextractor/models/tv_show.dart';
import 'package:plextractor/presentation/tv/tv_season_item.dart';
import 'package:plextractor/style.dart';

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
