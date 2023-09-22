import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_tv_show.dart';

class TvShowRowItem extends StatelessWidget {
  const TvShowRowItem({
    super.key,
    required this.tvShow,
  });

  final TvdbTvShow tvShow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (tvShow.artworkPath != null)
              Image.network(
                tvShow.artworkPath!,
                width: 75,
                height: 120,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvShow.name,
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (tvShow.startyear != null && tvShow.endYear != null)
                    Row(
                      children: [
                        Text(
                          tvShow.startyear!,
                          style: style,
                        ),
                        const Text(" - "),
                        Text(
                          tvShow.endYear!,
                          style: style,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        ...tvShow.seasons
                ?.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(e),
                  ),
                )
                .toList() ??
            []
      ],
    );
  }

  TextStyle get style => const TextStyle(fontSize: 20);
}
