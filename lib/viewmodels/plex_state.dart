import 'package:equatable/equatable.dart';

class PlexState extends Equatable {
  final PlexStatus status;
  final String? error;

  const PlexState({
    required this.status,
    this.error,
  });

  const PlexState.init()
      : status = PlexStatus.init,
        error = null;

  const PlexState.loaded()
      : status = PlexStatus.loaded,
        error = null;

  const PlexState.error({
    required this.error,
  }) : status = PlexStatus.error;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

enum PlexStatus {
  init,
  loaded,
  error;
}
