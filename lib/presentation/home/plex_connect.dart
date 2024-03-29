import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final recentIp = prefs.getString("recentIp");
      final recentPort = prefs.getInt("recentPort");
      controller.addListener(() {
        setState(() {});
      });
      portController.addListener(() {
        setState(() {});
      });
      if (recentIp != null) controller.text = recentIp;
      if (recentPort != null) portController.text = recentPort.toString();
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
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
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
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
              )
            ],
          ),
        );
      },
    );
  }
}
