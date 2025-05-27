import 'dart:io';

import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

enum LogType { info, progress, success, error }

class BrandForge {
  static void changeAppName(ForgePlatform platform, String newName) {
    _log(
      'Changing app name for ${platform.name} to "$newName"...',
      type: LogType.progress,
    );
    switch (platform) {
      case ForgePlatform.iOS:
        _changeAppNameIOS(newName);
        break;
      case ForgePlatform.android:
        _changeAppNameAndroid(newName);
        break;
      case ForgePlatform.windows:
        _changeAppNameWindows(newName);
        break;
      case ForgePlatform.macOS:
        _changeAppNameMacOS(newName);
        break;
      case ForgePlatform.linux:
        _changeAppNameLinux(newName);
        break;
    }
  }

  static void changeAppIcon(ForgePlatform platform, String iconPath) {
    final File iconFile = File(iconPath);
    if (!iconFile.existsSync()) {
      _log('Error: Icon file not found at $iconPath', type: LogType.error);
      return;
    }
    _log(
      'Changing app icon for ${platform.name} using $iconPath...',
      type: LogType.progress,
    );
    switch (platform) {
      case ForgePlatform.iOS:
        _changeAppIconIOS(iconPath);
        break;
      case ForgePlatform.android:
        _changeAppIconAndroid(iconPath);
        break;
      case ForgePlatform.windows:
        _log(
          'Windows app icon change not yet implemented.',
          type: LogType.info,
        );
        break;
      case ForgePlatform.macOS:
        _log('macOS app icon change not yet implemented.', type: LogType.info);
        break;
      case ForgePlatform.linux:
        _log('Linux app icon change not yet implemented.', type: LogType.info);
        break;
    }
  }

  static void _changeAppNameIOS(String newName) {
    final String projectRoot = _findProjectRoot();
    final String infoPlistPath = p.join(
      projectRoot,
      'ios',
      'Runner',
      'Info.plist',
    );
    final File infoPlistFile = File(infoPlistPath);

    if (!infoPlistFile.existsSync()) {
      _log(
        'Error: Info.plist not found at $infoPlistPath',
        type: LogType.error,
      );
      return;
    }

    String content = infoPlistFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'<key>CFBundleDisplayName</key>\s*<string>.*?</string>'),
      '<key>CFBundleDisplayName</key>\n<string>$newName</string>',
    );
    content = content.replaceAll(
      RegExp(r'<key>CFBundleName</key>\s*<string>.*?</string>'),
      '<key>CFBundleName</key>\n<string>$newName</string>',
    );

    infoPlistFile.writeAsStringSync(content);
    _log('iOS app name updated to "$newName"', type: LogType.success);
  }

  static void _changeAppNameAndroid(String newName) {
    final String projectRoot = _findProjectRoot();
    final String manifestPath = p.join(
      projectRoot,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );
    final File manifestFile = File(manifestPath);

    if (!manifestFile.existsSync()) {
      _log(
        'Error: AndroidManifest.xml not found at $manifestPath',
        type: LogType.error,
      );
      return;
    }

    final document = XmlDocument.parse(manifestFile.readAsStringSync());
    final applicationElement = document.findAllElements('application').first;

    final labelAttribute = applicationElement.attributes.firstWhere(
      (attr) => attr.name.local == 'label',
      orElse: () => XmlAttribute(XmlName('label'), ""),
    );

    if (labelAttribute.name.local == 'label') {
      labelAttribute.value = newName;
    } else {
      applicationElement.attributes.add(
        XmlAttribute(XmlName('label'), newName),
      );
    }
    manifestFile.writeAsStringSync(
      document.toXmlString(pretty: true, indent: '  '),
    );
    _log('Android app name updated to "$newName"', type: LogType.success);
  }

  static void _changeAppNameWindows(String newName) {
    final String projectRoot = _findProjectRoot();
    final String mainCppPath = p.join(
      projectRoot,
      'windows',
      'runner',
      'main.cpp',
    );
    final File mainCppFile = File(mainCppPath);

    if (!mainCppFile.existsSync()) {
      _log(
        'Error: Windows main.cpp file not found at $mainCppPath',
        type: LogType.error,
      );
      return;
    }

    String content = mainCppFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'!window\.Create\(L"(.*?)"'),
      (match) => '!window.Create(L"$newName"',
    );

    mainCppFile.writeAsStringSync(content);
    _log('Windows app name updated to "$newName"', type: LogType.success);
  }

  static void _changeAppNameMacOS(String newName) {
    final String projectRoot = _findProjectRoot();
    final String infoPlistPath = p.join(
      projectRoot,
      'macos',
      'Runner',
      'Info.plist',
    );
    final File infoPlistFile = File(infoPlistPath);

    if (!infoPlistFile.existsSync()) {
      _log(
        'Error: Info.plist not found at $infoPlistPath',
        type: LogType.error,
      );
      return;
    }

    String content = infoPlistFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'<key>CFBundleName</key>\s*<string>.*?</string>'),
      '<key>CFBundleName</key>\n<string>$newName</string>',
    );

    infoPlistFile.writeAsStringSync(content);
    _log('macOS app name updated to "$newName"', type: LogType.success);
  }

  static void _changeAppNameLinux(String newName) {
    final String projectRoot = _findProjectRoot();
    final String applicationPath= p.join(
      projectRoot,
      'linux',
      'runner',
      'my_application.cc',
    );
    final File applicationFile = File(applicationPath);

    if (!applicationFile.existsSync()) {
      _log(
        'Error: Linux my_application.cc file not found at $applicationPath',
        type: LogType.error,
      );
      return;
    }

    String content = applicationFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r'gtk_header_bar_set_title\(header_bar, ".*?"\)'),
      'gtk_header_bar_set_title(header_bar, "$newName")',
    );
    content = content.replaceAll(
      RegExp(r'gtk_window_set_title\(window, ".*?"\)'),
      'gtk_window_set_title(window, "$newName")',
    );

    applicationFile.writeAsStringSync(content);
    _log('Linux app name updated to "$newName"', type: LogType.success);
  }

  static void _changeAppIconIOS(String iconPath) {
    final String projectRoot = _findProjectRoot();
    final String assetPath = p.join(
      projectRoot,
      'ios',
      'Runner',
      'Assets.xcassets',
      'AppIcon.appiconset',
    );
    final Directory assetDir = Directory(assetPath);

    if (!assetDir.existsSync()) {
      _log(
        'Error: iOS Asset directory not found at $assetPath',
        type: LogType.error,
      );
      return;
    }
    // Copy new icon to asset folder
    final String newIconPath = p.join(assetDir.path, 'icon.png');
    File(iconPath).copySync(newIconPath);
    _log('iOS app icon updated.', type: LogType.success);
  }

  static void _changeAppIconAndroid(String iconPath) {
    final String projectRoot = _findProjectRoot();
    final String mipmapPath = p.join(
      projectRoot,
      'android',
      'app',
      'src',
      'main',
      'res',
    );
    final Directory mipmapDir = Directory(mipmapPath);

    if (!mipmapDir.existsSync()) {
      _log(
        'Error: Android mipmap directory not found at $mipmapPath',
        type: LogType.error,
      );
      return;
    }
    // Copy new icon to mipmap folder
    final List<String> densites = [
      'mipmap-mdpi',
      'mipmap-hdpi',
      'mipmap-xhdpi',
      'mipmap-xxhdpi',
      'mipmap-xxxhdpi',
    ];

    for (var density in densites) {
      final String destDir = p.join(mipmapPath, density);
      if (Directory(destDir).existsSync()) {
        final String newIconPath = p.join(destDir, 'ic_launcher.png');
        File(iconPath).copySync(newIconPath);
      }
    }

    _log('Android app icon updated.', type: LogType.success);
  }

  static String _findProjectRoot() {
    Directory current = Directory.current;
    while (current.path != current.parent.path) {
      if (File(p.join(current.path, 'pubspec.yaml')).existsSync()) {
        return current.path;
      }
      current = current.parent;
    }
    throw Exception('Could not find project root directory.');
  }

  // Private helper method to log messages with prefixes.
  static void _log(
    String message, {
    LogType type = LogType.info,
    bool showPrefixEmoji = true,
  }) {
    String prefix = '';
    String emoji = '';
    if (showPrefixEmoji) {
      // Only add prefix and emoji if showPrefixEmoji is true
      switch (type) {
        case LogType.info:
          prefix = '[INFO]';
          emoji = 'ℹ️'; // Information symbol
          break;
        case LogType.progress:
          prefix = '[PROGRESS]';
          emoji = '⏳'; //  arrow
          break;
        case LogType.success:
          prefix = '[SUCCESS]';
          emoji = '✅'; // Check mark
          break;
        case LogType.error:
          prefix = '[ERROR]';
          emoji = '❌'; // Cross mark
          break;
      }
    }
    // ignore: avoid_print
    print(
      '$prefix$emoji $message',
    ); // Concatenate prefix and emoji only if needed
  }

  static void showIntroduction() {
    // ASCII art for "BrandForge"
    final brandForgeArt = '''
     ____                      _ ______                   
    |  _ \\                    | |  ____|                  
    | |_) |_ __ __ _ _ __   __| | |__ ___  _ __ __ _  ___ 
    |  _ <| '__/ _` | '_ \\ / _` |  __/ _ \\| '__/ _` |/ _ \\
    | |_) | | | (_| | | | | (_| | | | (_) | | | (_| |  __/
    |____/|_|  \\__,_|_| |_|\\__,_|_|  \\___/|_|  \\__, |\\___|
                                                __/ |     
                                                |___/     
    ''';
    _log('\n$brandForgeArt', type: LogType.info, showPrefixEmoji: false);
    _log(
      'Welcome to BrandForge! 🎉',
      type: LogType.info,
      showPrefixEmoji: false,
    );
    _log(
      'This tool helps you dynamically change your app\'s name and icon.',
      type: LogType.info,
      showPrefixEmoji: false,
    );
    _log(
      'Use --help to see available commands.',
      type: LogType.info,
      showPrefixEmoji: false,
    );
  }
}
