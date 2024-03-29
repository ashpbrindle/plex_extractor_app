import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton(
    this.state, {
    super.key,
    required this.ip,
    required this.port,
    this.movies1Path,
    this.movies2Path,
    this.tv1Path,
    this.tv2Path,
  });

  final PlexState state;
  final String ip;
  final String port;
  final String? movies1Path;
  final String? movies2Path;
  final String? tv1Path;
  final String? tv2Path;

  @override
  Widget build(BuildContext context) {
    bool showConnect = state.media.values.toList().isEmpty;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (ip.isEmpty || port.isEmpty) return;
        return context.read<PlexCubit>().extractMedia(ip, int.parse(port));
      },
      child: Opacity(
        opacity: ip.isEmpty || port.isEmpty ? 0.2 : 1.0,
        child: Stack(
          children: [
            if (state.status == PlexStatus.loading)
              const Positioned.fill(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: ip.isEmpty || port.isEmpty
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
                    color: ip.isEmpty || port.isEmpty
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
