import 'package:equatable/equatable.dart';

class UserCredentials extends Equatable {
  final String? username;
  final String? authToken;
  final String? ip;
  final String? port;

  const UserCredentials({
    this.username,
    this.authToken,
    this.ip,
    this.port,
  });

  @override
  List<Object?> get props => [
        username,
        authToken,
        ip,
        port,
      ];
}
