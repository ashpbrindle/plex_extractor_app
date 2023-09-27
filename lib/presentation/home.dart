import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/presentation/movie_row_item.dart';
import 'package:plex_extractor_app/presentation/title_row_item.dart';
import 'package:plex_extractor_app/presentation/tv_row_item.dart';
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
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = "127.0.0.1";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(222, 222, 222, 1),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<PlexCubit, PlexState>(builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Center(
                        child: TextField(
                          controller: controller,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PlexCubit>()
                              .retrieveMovies(controller.text);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: state.status == PlexStatus.loading
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
                      if (state.movies.isNotEmpty)
                        const TitleRowItem(title: "Movies"),
                      ...state.movies
                          .map(
                            (e) => MovieRowItem(movie: e),
                          )
                          .toList(),
                      if (state.tvShow.isNotEmpty)
                        const TitleRowItem(title: "Tv Shows"),
                      ...state.tvShow
                          .map(
                            (e) => TvRowItem(tvShow: e),
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
