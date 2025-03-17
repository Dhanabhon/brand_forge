import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NameChanger {
  static const platform = MethodChannel('brandforge/name');

  Future<void> setAppName(String newName) async {
    try {
      await platform.invokeMethod('setAppName', {'newName': newName});
      if (kDebugMode) {
        print('App name changed to: $newName');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to set app name: '${e.message}'.");
      }
    }
  }
}
