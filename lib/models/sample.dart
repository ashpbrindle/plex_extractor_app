import 'package:plex_extractor_app/models/movie.dart';
import 'package:plex_extractor_app/models/tv_show.dart';

List<Movie> sampleMovies = [
  Movie(name: "Elemental (2023)", tvdb: "337156"),
  Movie(name: "Blue Beetle (2023)", tvdb: "156176"),
  Movie(name: "The Nun II (2023)", tvdb: "340887"),
];
List<TvShow> sampleTvShows = [
  TvShow(
    name: "Adventure Time",
    seasonsNames: {
      "Season 01": "221091",
      "Season 02": "329151",
    },
    tvdb: "152831",
  )
];
