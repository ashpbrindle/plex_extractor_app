import 'package:flutter/material.dart';
import 'package:plex_extractor_app/presentation/home/text_input.dart';

class FolderPathDropDown extends StatelessWidget {
  const FolderPathDropDown({
    super.key,
    required this.movies1Controller,
    required this.movies2Controller,
    required this.tv1Controller,
    required this.tv2Controller,
  });

  final TextEditingController movies1Controller;
  final TextEditingController movies2Controller;
  final TextEditingController tv1Controller;
  final TextEditingController tv2Controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.grey.shade400,
          backgroundColor: Colors.grey.shade400,
          title: const Text(
            "Folder Paths",
            style: TextStyle(fontSize: 12),
          ),
          children: [
            TextInput(
              hintText: "Movies 1 Folder...",
              controller: movies1Controller,
            ),
            TextInput(
              hintText: "Movies 2 Folder...",
              controller: movies2Controller,
            ),
            TextInput(
              hintText: "TV 1 Folder...",
              controller: tv1Controller,
            ),
            TextInput(
              hintText: "TV 2 Folder...",
              controller: tv2Controller,
            ),
          ],
        ),
      ),
    );
  }
}
