import 'package:plex_extractor_app/models/tvdb/tvdb_movie.dart';
import 'package:plex_extractor_app/models/tvdb/tvdb_tv_show.dart';

extension MovieListExtension on List<TvdbMovie> {
  List<TvdbMovie> get sortByName {
    final newList = [...this];
    newList.sort((movie1, movie2) => movie1.name.compareTo(movie2.name));
    return newList;
  }
}

extension TvShowListExtension on List<TvdbTvShow> {
  List<TvdbTvShow> get sortByName {
    final newList = [...this];
    newList.sort((tvShow1, tvShow2) => tvShow1.name.compareTo(tvShow2.name));
    return newList;
  }
}
