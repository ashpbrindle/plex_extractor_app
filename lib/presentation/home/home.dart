import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/home/folder_path_drop_down.dart';
import 'package:plex_extractor_app/presentation/home/movies_view.dart';
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
  final TextEditingController movies1Controller = TextEditingController();
  final TextEditingController movies2Controller = TextEditingController();
  final TextEditingController tv1Controller = TextEditingController();
  final TextEditingController tv2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
    movies1Controller.addListener(() => setState(() {}));
    movies2Controller.addListener(() => setState(() {}));
    tv1Controller.addListener(() => setState(() {}));
    tv2Controller.addListener(() => setState(() {}));
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
                List<Movie> filteredMovies = state.movies
                    .where((movie) => movie.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
                List<TvShow> filteredTvShows = state.tvShow
                    .where((tvShow) => tvShow.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();
                return Column(
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 14, 25, 74),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            PlexConnect(
                              movies1Path: movies1Controller.text,
                              movies2Path: movies2Controller.text,
                              tv1Path: tv1Controller.text,
                              tv2Path: tv2Controller.text,
                            ),
                            TextInput(
                              controller: searchController,
                              hintText: "Search...",
                            ),
                            FolderPathDropDown(
                              movies1Controller: movies1Controller,
                              movies2Controller: movies2Controller,
                              tv1Controller: tv1Controller,
                              tv2Controller: tv2Controller,
                            )
                          ],
                        ),
                      ),
                    ),
                    MoviesView(
                      movies: filteredMovies,
                      lastSavedDate: state.lastSavedMovie,
                      status: state.movieStatus,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TvView(
                      tvShows: filteredTvShows,
                      lastSavedDate: state.lastSavedTvShow,
                      status: state.tvShowStatus,
                    ),
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
