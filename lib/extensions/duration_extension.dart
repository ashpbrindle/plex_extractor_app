extension DurationExtension on Duration {
  String get prettify {
    var components = <String>[];

    var days = inDays;
    if (days != 0) {
      components.add('${days}d ');
    }
    var hours = inHours % 24;
    if (hours != 0) {
      components.add('${hours}hr ');
    }
    var minutes = inMinutes % 60;
    if (minutes != 0) {
      components.add('${minutes}m');
    }

    var seconds = inSeconds % 60;
    var centiseconds = (inMilliseconds % 1000) ~/ 10;
    if (components.isEmpty || seconds != 0 || centiseconds != 0) {
      components.add('$seconds');
      if (centiseconds != 0) {
        components.add('.');
        components.add(centiseconds.toString().padLeft(2, '0'));
      }
      components.add('s');
    }
    return components.join();
  }
}
