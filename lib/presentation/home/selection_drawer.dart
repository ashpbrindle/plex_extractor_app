import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/presentation/home/login_bottom_sheet.dart';
import 'package:plex_extractor_app/presentation/home/login_button.dart';
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      if (state.lastSaved != null) ...[
                        const Text(
                          "Last Successful Full Sync:",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueGrey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20,
                            ),
                            child: Center(
                              child: state.globalStatus == PlexStatus.loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "${state.lastSaved}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.media
                          .map(
                            (e) => StatusView(
                              media: e,
                              complete: state.globalStatus != PlexStatus.loading,
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginButton(
                  token: state.credentials.authToken,
                  loginStatus: state.plexLoginStatus,
                  savedUsername: state.credentials.username,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
