import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'common_helper.dart';

class ImageUtils {
  static Uint8List base64ToImage({required String string}) {
    try {
      return base64Decode(string);
    } catch (e) {
      CommonHelper.printDebugError(e, "ImageUtils line no 16");
    }
    return Uint8List(0);
  }

  static String fileToBase64({required String path}) {
    File file = File(path);
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }

}
