import 'dart:math';

extension IntFormatter on int {
  String formatBytes({int decimal = 1}) {
    if (this <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(this) / log(1024)).floor();
    return '${((this / pow(1024, i)).toStringAsFixed(decimal))} ${suffixes[i]}';
  }
}
