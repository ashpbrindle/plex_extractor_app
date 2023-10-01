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
          child: BlocBuilder<PlexCubit, PlexState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: "Enter IP Address",
                                  contentPadding: EdgeInsets.all(20.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            context
                                .read<PlexCubit>()
                                .extractMedia(controller.text);
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Center(
                                child: Icon(
                                  Icons.replay_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Movies"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(state.lastSavedMovie ?? ""),
                              const SizedBox(
                                width: 10,
                              ),
                              Builder(
                                builder: (context) =>
                                    switch (state.movieStatus) {
                                  PlexStatus.init => Container(),
                                  PlexStatus.loading => const Icon(
                                      Icons.download,
                                      color: Colors.grey,
                                    ),
                                  PlexStatus.error => const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  PlexStatus.loaded => const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    children: [
                      if (state.movies.isNotEmpty)
                        ...state.movies
                            .map(
                              (e) => MovieRowItem(movie: e),
                            )
                            .toList(),
                    ],
                  ),
                  if (state.movieStatus == PlexStatus.loading)
                    LinearProgressIndicator(
                      color: Colors.orange,
                      backgroundColor: Colors.orange.withOpacity(0.3),
                    ),
                  ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TV Shows"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(state.lastSavedTvShow ?? ""),
                              const SizedBox(width: 10),
                              Builder(
                                builder: (context) =>
                                    switch (state.tvShowStatus) {
                                  PlexStatus.init => Container(),
                                  PlexStatus.loading => const Icon(
                                      Icons.download,
                                      color: Colors.grey,
                                    ),
                                  PlexStatus.error => const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  PlexStatus.loaded => const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    children: [
                      if (state.tvShow.isNotEmpty)
                        ...state.tvShow
                            .map(
                              (e) => TvRowItem(tvShow: e),
                            )
                            .toList(),
                    ],
                  ),
                  if (state.tvShowStatus == PlexStatus.loading)
                    LinearProgressIndicator(
                      color: Colors.orange,
                      backgroundColor: Colors.orange.withOpacity(0.3),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
