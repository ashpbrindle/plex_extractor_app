import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/movie/media_row_item.dart';
import 'package:plex_extractor_app/presentation/tv/tv_row_item.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';

class LibrarySectionWidget extends StatelessWidget {
  const LibrarySectionWidget({
    super.key,
    required this.library,
  });

  final PlexLibrary library;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 14, 25, 74),
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.white),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      library.name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        library.medias.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final media = library.medias[i];
            if (media is TvShow) {
              return TvRowItem(tvShow: media);
            } else {
              return MediaRowItem(media: media);
            }
          },
          childCount: library.medias.length,
        ),
      ),
    );
  }
}
