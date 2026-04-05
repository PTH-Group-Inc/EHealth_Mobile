import 'package:flutter/foundation.dart';

class LogHelper {
  static void printLongString(Object? object) {
    if (object == null) return;
    final text = object.toString();
    const int chunkSize = 800; // Android Logcat limit is around 1024-4096 bytes per line
    
    if (text.length <= chunkSize) {
      debugPrint(text);
    } else {
      for (int i = 0; i < text.length; i += chunkSize) {
        final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
        debugPrint(text.substring(i, end));
      }
    }
  }
}
