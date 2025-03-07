import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plextractor/api/plex/plex_api.dart';
import 'package:plextractor/api/plex/plex_repository.dart';
import 'package:plextractor/presentation/home/home.dart';
import 'package:plextractor/viewmodels/plex_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PlexCubit(
            plexRepository: PlexRepository(
              api: PlexApi(),
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          )..init(),
        )
      ],
      child: const Home(),
    ),
  );
}
