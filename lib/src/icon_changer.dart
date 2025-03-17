import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IconChanger {
  static const platform = MethodChannel('brandforge/icon');

  Future<void> setIconFromAsset(String assetPath) async {
    try {
      await platform.invokeMethod('setIconFromAsset', {'assetPath': assetPath});
      if (kDebugMode) {
        print('App icon changed from asset: $assetPath');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to set app icon from asset: '${e.message}'.");
      }
    }
  }

  Future<void> setIconFromFile(File file) async {
    try {
      await platform.invokeMethod('setIconFromFile', {'filePath': file.path});
      if (kDebugMode) {
        print('App icon changed from file: ${file.path}');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to set app icon from file: '${e.message}'.");
      }
    }
  }

  Future<void> setIconFromUrl(String url) async {
    try {
      await platform.invokeMethod('setIconFromUrl', {'url': url});
      if (kDebugMode) {
        print('App icon changed from URL: $url');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to set app icon from URL: '${e.message}'.");
      }
    }
  }
}
