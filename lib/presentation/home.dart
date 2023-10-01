import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/presentation/movie_row_item.dart';
import 'package:plex_extractor_app/presentation/tv_row_item.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences.getInstance().then((prefs) {
      final recentIp = prefs.getString("recentIp");
      controller.text = recentIp ?? "localhost";
    });
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
                              .extractMedia(controller.text);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          state.status.getStatus(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (state.movies.isNotEmpty)
                        ExpansionTile(
                          title: const Text("Movies"),
                          children: state.movies
                              .map(
                                (e) => MovieRowItem(movie: e),
                              )
                              .toList(),
                        ),
                      if (state.tvShow.isNotEmpty)
                        ExpansionTile(
                          title: const Text("Tv Shows"),
                          children: state.tvShow
                              .map(
                                (e) => TvRowItem(tvShow: e),
                              )
                              .toList(),
                        ),
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
