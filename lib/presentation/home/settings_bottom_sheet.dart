import 'package:flutter/material.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // doSomething();
              },
              child: const Text("Item 1")),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // doSomething();
              },
              child: const Text("Item 2")),
        ]),
      ),
    );
  }
}
