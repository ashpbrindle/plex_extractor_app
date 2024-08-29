import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/api/plex/plex_repository.dart';
import 'package:plex_extractor_app/presentation/home/refresh_button.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexConnect extends StatefulWidget {
  const PlexConnect({
    super.key,
    this.movies1Path,
    this.movies2Path,
    this.tv1Path,
    this.tv2Path,
  });

  final String? movies1Path;
  final String? movies2Path;
  final String? tv1Path;
  final String? tv2Path;

  @override
  State<PlexConnect> createState() => _PlexConnectState();
}

class _PlexConnectState extends State<PlexConnect> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final recentIp = prefs.getString(SavedValue.ip.key);
      final recentPort = prefs.getString(SavedValue.port.key);
      final recentToken = prefs.getString(SavedValue.token.key);
      controller.addListener(() {
        setState(() {});
      });
      portController.addListener(() {
        setState(() {});
      });
      tokenController.addListener(() {
        setState(() {});
      });
      if (recentIp != null) controller.text = recentIp;
      if (recentPort != null) portController.text = recentPort;
      if (recentToken != null) tokenController.text = recentToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlexCubit, PlexState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${state.error}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      },
      listenWhen: (state1, state2) =>
          state1.error != state2.error && state2.error != null,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Enter IP Address",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                        controller: portController,
                        decoration: const InputDecoration(
                          hintText: "Enter Port",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        controller: tokenController,
                        decoration: const InputDecoration(
                          hintText: "Enter Token",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            RefreshButton(
              state,
              ip: controller.text,
              port: portController.text,
              movies1Path: widget.movies1Path,
              movies2Path: widget.movies2Path,
              tv1Path: widget.tv1Path,
              tv2Path: widget.tv2Path,
              token: tokenController.text,
            )
          ],
        );
      },
    );
  }
}
