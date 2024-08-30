import 'package:equatable/equatable.dart';
import 'package:plex_extractor_app/viewmodels/plex_library.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plex_state.freezed.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}

// class PlexState extends Equatable {
//   final List<PlexLibrary> media;
//   final String? recentIp;
//   final String? recentPort;
//   final String? recentToken;
//   final String? error;
//   final String? lastSaved;
//   final PlexStatus globalStatus;
//   final PlexLoginStatus plexLoginStatus;

//   const PlexState({
//     required this.recentIp,
//     required this.recentPort,
//     required this.recentToken,
//     required this.media,
//     required this.lastSaved,
//     required this.globalStatus,
//     required this.plexLoginStatus,
//     this.error,
//   });

//   PlexState.init()
//       : lastSaved = null,
//         media = [],
//         recentIp = null,
//         recentPort = null,
//         recentToken = null,
//         error = null,
//         plexLoginStatus = PlexLoginStatus.noAuthToken,
//         globalStatus = PlexStatus.init;

//   PlexState copyWith({
//     List<PlexLibrary>? media,
//     String? recentIp,
//     String? recentPort,
//     String? recentToken,
//     String? error,
//     String? lastSaved,
//     PlexStatus? globalStatus,
//     PlexLoginStatus? plexLoginStatus,
//   }) {
//     return PlexState(
//       recentIp: recentIp ?? this.recentIp,
//       recentPort: recentPort ?? this.recentPort,
//       recentToken: recentToken ?? this.recentToken,
//       error: error ?? this.error,
//       media: media ?? this.media,
//       globalStatus: globalStatus ?? this.globalStatus,
//       lastSaved: lastSaved ?? this.lastSaved,
//       plexLoginStatus: plexLoginStatus ?? this.plexLoginStatus,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         media,
//         recentIp,
//         recentPort,
//         recentToken,
//         lastSaved,
//         plexLoginStatus,
//         error,
//       ];
// }

enum PlexStatus {
  init,
  loading,
  loaded,
  error;
}

enum PlexLoginStatus {
  noAuthToken,
  hasAuthToken,
  loading;
}
