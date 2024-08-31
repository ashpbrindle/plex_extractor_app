import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/home/selection_drawer.dart';
import 'package:plex_extractor_app/presentation/home/text_input.dart';
import 'package:plex_extractor_app/presentation/movie/media_row_item.dart';
import 'package:plex_extractor_app/presentation/tv/tv_row_item.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  bool show4k = true;
  bool show1080 = true;
  bool showOther = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true),
      home: BlocBuilder<PlexCubit, PlexState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 178, 193, 201),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (state.media.isNotEmpty)
                  Row(
                    children: [
                      const Text(
                        "4K",
                        style: TextStyle(fontSize: 12),
                      ),
                      Switch(
                        value: show4k,
                        onChanged: (value) {
                          setState(() {
                            show4k = value;
                          });
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Text(
                      "1080p",
                      style: TextStyle(fontSize: 12),
                    ),
                    Switch(
                      value: show1080,
                      onChanged: (value) {
                        setState(() {
                          show1080 = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Other",
                      style: TextStyle(fontSize: 12),
                    ),
                    Switch(
                      value: showOther,
                      onChanged: (value) {
                        setState(() {
                          showOther = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          drawer: const SelectionDrawer(),
          backgroundColor: const Color.fromARGB(255, 178, 193, 201),
          body: SafeArea(
            child: state.media.isNotEmpty
                ? Column(
                    children: [
                      TextInput(
                        controller: searchController,
                        hintText: "Search...",
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            ...state.media
                                .filterByName(searchController.text)
                                .filterByQuality(show4k, show1080, showOther)
                                .map(
                                  (e) => SliverStickyHeader(
                                    header: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 14, 25, 74),
                                            border: Border.symmetric(
                                              horizontal: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    e.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    e.items.length.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
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
                                          final media = e.items[i];
                                          if (media is TvShow) {
                                            return TvRowItem(tvShow: media);
                                          } else {
                                            return MediaRowItem(media: media);
                                          }
                                        },
                                        childCount: e.items.length,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(state.error ??
                        "No Data found, Open the menu to Connect"),
                  ),
          ),
        );
      }),
    );
  }
}

final globalNavigatorKey = GlobalKey<NavigatorState>();
