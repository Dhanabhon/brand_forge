import 'package:flutter/services.dart';

class NameChanger {
  static const platform = MethodChannel('brandforge/name');

  Future<String> changeAppName(String newName, {String? targetPlatform}) async {
    final result = await platform.invokeMethod('changeName', {
      'newName': newName,
      'platform': targetPlatform,
    });

    return result as String;
  }
}
