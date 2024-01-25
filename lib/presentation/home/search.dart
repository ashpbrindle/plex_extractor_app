import 'package:flutter/material.dart';
import 'package:plex_extractor_app/presentation/home/settings_bottom_sheet.dart';

class Search extends StatelessWidget {
  const Search({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
                    hintText: "Search...",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => const SettingsBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
