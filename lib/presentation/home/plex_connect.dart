import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plex_extractor_app/viewmodels/plex_cubit.dart';
import 'package:plex_extractor_app/viewmodels/plex_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlexConnect extends StatefulWidget {
  const PlexConnect({super.key});

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
              getPlexIcon(state, controller.text, portController.text)
            ],
          ),
        );
      },
    );
  }

  Widget getPlexIcon(PlexState state, String ip, String port) {
    bool showConnect = state.movies.isEmpty && state.tvShow.isEmpty;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (ip.isEmpty || port.isEmpty) return;
        return context.read<PlexCubit>().extractMedia(
              controller.text,
              int.parse(portController.text),
            );
      },
      child: Container(
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
              color:
                  ip.isEmpty || port.isEmpty ? Colors.blueGrey : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
