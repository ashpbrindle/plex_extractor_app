// part of tmdb;

// class _TmdbApi {
//   static const apiToken = "5d85f1ede52a096126b25478aa28ea39";
//   static const apiReadAccessToken =
//       "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZDg1ZjFlZGU1MmEwOTYxMjZiMjU0NzhhYTI4ZWEzOSIsInN1YiI6IjY1MTMwYTQ4MjZkYWMxMDEwYzc3MzI0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KRK6uFO-5E92T0h5XubYeWQzuNcMFJmGZ8ZuTxOSNJQ";
//   static const endpoint = "https://api.themoviedb.org/3/";

//   final Dio dio = Dio();

//   _TmdbApi() {
//     dio.options.headers["Authorization"] = "Bearer $apiReadAccessToken";
//     // dio.options.headers["accept"] = "application/json";
//   }

//   Future<Map<String, dynamic>?> getMovie(Movie? movie) async {
//     if (movie?.name != null && movie?.year != null) {
//       final response = await dio.get(
//           "$endpoint/search/movie?query=${movie!.name}&include_adult=false&language=en-US&primary_release_year=${movie.year}&page=1");
//       if (response.statusCode == 200) {
//         try {
//           final response2 = await dio.get(
//               "$endpoint/movie/${response.data["results"].first["id"]}?language=en-US");
//           print("Found - ${movie.name}");
//           return response2.data;
//         } catch (e) {
//           print("Failed - ${movie.name}");
//           return null;
//         }
//       }
//     }
//     return null;
//   }

//   Future<Map<String, dynamic>?> getTvShow(TvShow? tvShow) async {
//     // await _login();
//     if (tvShow?.tvdb != null) {
//       final response = await dio.get("$endpoint/series/${tvShow!.tvdb}");
//       if (response.statusCode == 200) {
//         return response.data["data"];
//       }
//     }
//     return null;
//   }
// }
