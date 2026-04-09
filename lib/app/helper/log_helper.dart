import 'dart:developer' as dev;

class LogHelper {
  static void printLongString(Object? object) {
    if (object == null) return;
    final text = object.toString();
    const int chunkSize = 1000;
    
    if (text.length <= chunkSize) {
      dev.log(text, name: 'EHealth');
    } else {
      for (int i = 0; i < text.length; i += chunkSize) {
        final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
        dev.log(text.substring(i, end), name: 'EHealth');
      }
    }
  }
}
