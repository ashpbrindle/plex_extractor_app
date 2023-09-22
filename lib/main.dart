import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/api/tvdb/tvdb_repository.dart';
import 'package:plex_extractor_app/presentation/home.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/tvdb_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TvdbCubit(
            tvdbRepository: TvdbRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => PlexCubit(
            plexRepository: PlexRepository(),
          ),
        )
      ],
      child: const Home(),
    ),
  );
}
