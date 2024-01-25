import 'package:flutter/material.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({
    super.key,
  });

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  final primaryMovieController = TextEditingController();
  final secondaryMovieController = TextEditingController();
  final primaryTvController = TextEditingController();
  final secondaryTvController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text("Primary Movies Folder"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: primaryMovieController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text("Secondary Movies Folder"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: secondaryMovieController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text("Primary TV Folder"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: primaryTvController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text("Secondary TV Folder"),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: secondaryTvController,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
