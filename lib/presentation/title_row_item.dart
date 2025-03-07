import 'package:flutter/material.dart';
import 'package:plextractor/style.dart';

class TitleRowItem extends StatelessWidget {
  const TitleRowItem({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: style.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
