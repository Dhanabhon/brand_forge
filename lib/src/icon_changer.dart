import 'package:flutter/services.dart';

class IconChanger {
  static const platform = MethodChannel('brandforge/icon');

  Future<void> changeAppIcon(String iconPath) async {
    await platform.invokeMethod('changeIcon', {'iconPath': iconPath});
  }
}
