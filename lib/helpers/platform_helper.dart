import 'dart:io';

enum ForgePlatform {
  android,
  iOS,
  windows,
  macOS,
  linux;

  static ForgePlatform get current {
    if (Platform.isAndroid) return ForgePlatform.android;
    if (Platform.isIOS) return ForgePlatform.iOS;
    if (Platform.isWindows) return ForgePlatform.windows;
    if (Platform.isMacOS) return ForgePlatform.macOS;
    if (Platform.isLinux) return ForgePlatform.linux;
    throw UnsupportedError('Unsupported platform');
  }
}
