import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';
import 'package:plex_extractor_app/presentation/home/movies_view.dart';
import 'package:plex_extractor_app/presentation/home/plex_connect.dart';
import 'package:plex_extractor_app/presentation/home/search.dart';
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
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                            const PlexConnect(),
                            Search(controller: searchController),
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
