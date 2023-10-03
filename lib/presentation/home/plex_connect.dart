import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexConnect extends StatefulWidget {
  const PlexConnect({super.key});

  @override
  State<PlexConnect> createState() => _PlexConnectState();
}

class _PlexConnectState extends State<PlexConnect> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final recentIp = prefs.getString("recentIp");
      controller.text = recentIp ?? "localhost";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Center(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Enter IP Address",
                    contentPadding: EdgeInsets.all(20.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              context.read<PlexCubit>().extractMedia(controller.text);
            },
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Center(
                  child: Icon(
                    Icons.replay_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
