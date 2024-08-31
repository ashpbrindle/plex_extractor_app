import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/presentation/home/login_bottom_sheet.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.token,
    required this.loginStatus,
    required this.savedUsername,
  });
  final String? token;
  final PlexLoginStatus loginStatus;
  final String? savedUsername;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (loginStatus == PlexLoginStatus.loading) {
          return;
        }
        if (token != null) {
          context.read<PlexCubit>().logout();
        } else {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => LoginBottomSheet(
              savedUsername: savedUsername,
              login: context.read<PlexCubit>().login,
              // (String username, String password) async {
              //   await context.read<PlexCubit>().login(username, password);
              // },
              loading: loginStatus == PlexLoginStatus.loading,
            ),
          );
        }
      },
      child: loginStatus == PlexLoginStatus.loading
          ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(),
            )
          : Text(token != null ? "Logout" : "Login"),
    );
  }
}
