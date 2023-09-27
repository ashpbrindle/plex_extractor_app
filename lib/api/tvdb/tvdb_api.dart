// part of tvdb;

// class _TvdbApi {
//   static const tvdbApiToken = "7ed3d8c2-bf53-45c2-92af-325bbdcb1de9";
//   static const endpoint = "https://api4.thetvdb.com/v4";

//   final Dio dio = Dio();

//   Future<void> _login() async {
//     final response = await dio.post("$endpoint/login",
//         data: jsonEncode({
//           "apikey": tvdbApiToken,
//         }));
//     final token = response.data["data"]["token"];
//     dio.options.headers["Authorization"] = "Bearer $token";
//   }

//   // Future<Map<String, dynamic>?> getMovie(Movie? movie) async {
//   //   await _login();
//   //   if (movie?.tvdb != null) {
//   //     final response = await dio.get("$endpoint/movies/${movie!.tvdb}");
//   //     if (response.statusCode == 200) {
//   //       return response.data["data"];
//   //     }
//   //   }
//   //   return null;
//   // }

//   // Future<Map<String, dynamic>?> getTvShow(TvShow? tvShow) async {
//   //   await _login();
//   //   if (tvShow?.tvdb != null) {
//   //     final response = await dio.get("$endpoint/series/${tvShow!.tvdb}");
//   //     if (response.statusCode == 200) {
//   //       return response.data["data"];
//   //     }
//   //   }
//   //   return null;
//   // }
// }
