import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/home/media_view.dart';
import 'package:plex_extractor_app/presentation/home/plex_connect.dart';
import 'package:plex_extractor_app/presentation/home/selection_drawer.dart';
import 'package:plex_extractor_app/presentation/home/status_view.dart';
import 'package:plex_extractor_app/presentation/home/text_input.dart';
import 'package:plex_extractor_app/presentation/home/tv_view.dart';
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
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 178, 193, 201),
        ),
        drawer: const SelectionDrawer(),
        backgroundColor: const Color.fromARGB(255, 178, 193, 201),
        body: SafeArea(
          child: BlocBuilder<PlexCubit, PlexState>(
            builder: (context, state) {
              List<PlexLibrary> filteredMovies =
                  _filteredMovies(state.media, searchController.text);
              return state.media.isNotEmpty
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
                              ...filteredMovies.map(
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
                                            horizontal:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              e.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, i) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(e.items[i].name),
                                      ),
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
                    );
            },
          ),
        ),
      ),
    );
  }

  List<PlexLibrary> _filteredMovies(List<PlexLibrary> media, String search) =>
      media
          .map((library) {
            List<Media> filteredItems = library.items
                .where((movie) =>
                    movie.name.toLowerCase().contains(search.toLowerCase()))
                .toList();
            return PlexLibrary(
                name: library.name,
                id: library.id,
                items: filteredItems,
                status: library.status);
          })
          .where((element) => element.items.isNotEmpty)
          .toList();
}

final globalNavigatorKey = GlobalKey<NavigatorState>();
