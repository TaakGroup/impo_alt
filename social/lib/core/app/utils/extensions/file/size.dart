import 'dart:io';
import 'dart:math';

extension SizeOfFile on File {
  String getStringSize() {
    final bytes = lengthSync();
    if (bytes <= 0) return "0 بایت";
    const suffixes = [" بایت", "کیلوبایت", "مگابایت", "گیگابایت", "ترابایت"];
    var i = (log(bytes) / log(1024)).floor();
    return "${((bytes / pow(1024, i))).toStringAsFixed(2)} ${suffixes[i]}";
  }
}