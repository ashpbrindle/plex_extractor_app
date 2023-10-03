import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/style.dart';

class TvEpisodeItem extends StatelessWidget {
  const TvEpisodeItem({
    super.key,
    required this.episode,
  });

  final TvShowEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            episode.name,
            style: style.copyWith(fontStyle: FontStyle.italic, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
