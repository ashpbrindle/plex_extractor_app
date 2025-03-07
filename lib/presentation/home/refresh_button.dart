import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plextractor/viewmodels/plex_cubit.dart';
import 'package:plextractor/viewmodels/plex_state.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton(
    this.state, {
    super.key,
    required this.ip,
    required this.port,
  });

  final PlexState state;
  final String ip;
  final String port;

  @override
  Widget build(BuildContext context) {
    bool showConnect = state.libraries.isEmpty;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (ip.isEmpty ||
            port.isEmpty ||
            state.credentials.authToken == null ||
            state.globalStatus == PlexStatus.loading) {
          return;
        }
        return context.read<PlexCubit>().extractMedia(ip, port);
      },
      child: Opacity(
        opacity: ip.isEmpty || port.isEmpty ? 0.2 : 1.0,
        child: Stack(
          children: [
            if (state.globalStatus == PlexStatus.loading)
              const Positioned.fill(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  
                ),
              ),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: ip.isEmpty ||
                        port.isEmpty ||
                        state.credentials.authToken == null ||
                        state.globalStatus == PlexStatus.loading
                    ? Colors.grey
                    : (showConnect ? Colors.green : Colors.purple),
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    showConnect ? Icons.cloud_download : Icons.sync,
                    color: ip.isEmpty ||
                            port.isEmpty ||
                            state.credentials.authToken == null
                        ? Colors.blueGrey
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
