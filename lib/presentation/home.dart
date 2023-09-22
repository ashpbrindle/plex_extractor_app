import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/extensions/list_extension.dart';
import 'package:plex_extractor_app/models/sample.dart';
import 'package:plex_extractor_app/presentation/movie_row_item.dart';
import 'package:plex_extractor_app/presentation/title_row_item.dart';
import 'package:plex_extractor_app/presentation/tv_show_row_item.dart';
import 'package:plex_extractor_app/viewmodels/tvdb_cubit.dart';
import 'package:plex_extractor_app/viewmodels/tvdb_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(222, 222, 222, 1),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Fetch from Plex"),
              ),
              BlocBuilder<TvdbCubit, TvdbState>(builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<TvdbCubit>().getMedia(sampleMovies);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: state.status == TvdbStatus.loading
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  "Load Media from TVDB",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                      if (state.movies.isNotEmpty)
                        const TitleRowItem(title: "Movies"),
                      ...state.movies.sortByName
                          .map(
                            (e) => MovieRowItem(movie: e),
                          )
                          .toList(),
                      if (state.tvShows.isNotEmpty)
                        const TitleRowItem(title: "TV Shows"),
                      ...state.tvShows.sortByName
                          .map(
                            (e) => TvShowRowItem(tvShow: e),
                          )
                          .toList(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
