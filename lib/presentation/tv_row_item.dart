import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plex_extractor_app/models/tv_show.dart';

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
            (season) => Padding(
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
                    .map(
                      (episode) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              episode.name,
                              style: style.copyWith(
                                  fontStyle: FontStyle.italic, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );

    // Row(
    //   children: [
    // if (tvShow.artworkPath != null)
    //   CachedNetworkImage(
    //     imageUrl: tvShow.artworkPath!,
    //     placeholder: (context, url) => const CircularProgressIndicator(),
    //     errorWidget: (context, url, error) => const Icon(Icons.error),
    //     width: 75,
    //     height: 120,
    //   ),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    // tvShow.name,
    // style: style.copyWith(fontWeight: FontWeight.bold),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Column(
    //               children: tvShow.seasons!
    //                   .map(
    //                     (e) => Column(children: [
    //                       Text(e.name),
    //                       ...e.episodes.map((e) => Text(e.name)).toList(),
    //                     ]),
    //                   )
    //                   .toList(),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  TextStyle get style => const TextStyle(fontSize: 20);
}
