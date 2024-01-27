import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/models/media.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/home/media_view.dart';
import 'package:plex_extractor_app/presentation/home/plex_connect.dart';
import 'package:plex_extractor_app/presentation/home/text_input.dart';
import 'package:plex_extractor_app/presentation/home/tv_view.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
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
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 178, 193, 201),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<PlexCubit, PlexState>(
              builder: (context, state) {
                Map<String, List<Media>> filteredMovies = {};
                for (final media in state.media.entries) {
                  filteredMovies.putIfAbsent(
                      media.key,
                      () => media.value
                          .where((movie) => movie.name
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList());
                }
                return Column(
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 14, 25, 74),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const PlexConnect(),
                            TextInput(
                              controller: searchController,
                              hintText: "Search...",
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blueGrey,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Text(
                                  state.lastSaved != null
                                      ? "${state.lastSaved}"
                                      : "N/A",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.status == PlexStatus.loading)
                      LinearProgressIndicator(
                        color: Colors.orange,
                        backgroundColor: Colors.orange.withOpacity(0.3),
                      ),
                    ...filteredMovies.entries.map((entry) {
                      final key = entry.key;
                      final values = entry.value;

                      if (values.isNotEmpty) {
                        if (values.first is TvShow) {
                          return TvView(
                            tvShows: values.cast<TvShow>().toList(),
                            status: state.status,
                          );
                        } else {
                          return MediaView(
                            name: key,
                            media: values,
                            status: state.status,
                          );
                        }
                      }
                      return const SizedBox();
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
