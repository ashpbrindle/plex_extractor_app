import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/style.dart';

class TvSeasonItem extends StatelessWidget {
  const TvSeasonItem({
    super.key,
    required this.season,
  });

  final TvShowSeason season;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            season.name,
            style: style,
          ),
        ),
        children: season.episodes
            .asMap()
            .entries
            .map(
              (episode) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (episode.key + 1).toString(),
                            style: style.copyWith(
                                fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            episode.value.name,
                            style: style.copyWith(
                                fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        episode.value.resolution ?? "",
                        style: style.copyWith(
                            fontStyle: FontStyle.italic, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
