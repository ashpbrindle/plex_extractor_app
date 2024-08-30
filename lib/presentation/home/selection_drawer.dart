import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/presentation/home/login_bottom_sheet.dart';
import 'package:plex_extractor_app/presentation/home/plex_connect.dart';
import 'package:plex_extractor_app/presentation/home/status_view.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class SelectionDrawer extends StatelessWidget {
  const SelectionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlexCubit, PlexState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: const Color.fromARGB(255, 178, 193, 201),
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 14, 25, 74),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      const PlexConnect(),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (state.recentToken != null) {
                            context.read<PlexCubit>().logout();
                          } else {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => LoginBottomSheet(
                                login:
                                    (String username, String password) async {
                                  await context
                                      .read<PlexCubit>()
                                      .login(username, password);
                                },
                                loading: state.plexLoginStatus ==
                                    PlexLoginStatus.loading,
                              ),
                            );
                          }
                        },
                        child: Text(
                            state.recentToken != null ? "Logout" : "Login"),
                      ),
                      const SizedBox(
                        height: 10,
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
              ...state.media
                  .map(
                    (e) => StatusView(
                      media: e,
                    ),
                  )
                  .toList()
            ],
          ),
        );
      },
    );
  }
}
