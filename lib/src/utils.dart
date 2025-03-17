import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

class Utils {
  static String getProjectRoot() {
    // Find the project root by traversing up from the current file
    Directory current = Directory.current;
    while (!File(p.join(current.path, 'pubspec.yaml')).existsSync()) {
      current = current.parent;
      if (current.path == current.parent.path) {
        throw Exception('Could not find project root directory.');
      }
    }
    return current.path;
  }

  static void updateAndroidManifest(String newName) {
    _log('Updating AndroidManifest.xml...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final androidManifestPath = p.join(
      rootPath,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );
    final manifestFile = File(androidManifestPath);
    if (!manifestFile.existsSync()) {
      throw Exception('AndroidManifest.xml not found at $androidManifestPath');
    }

    String content = manifestFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'android:label="([^"]*)"'),
      (match) => 'android:label="$newName"',
    );

    manifestFile.writeAsStringSync(content);
    _log('Updated AndroidManifest.xml', type: LogType.success);
  }

  static void updateInfoPlist(String newName) {
    _log('Updating Info.plist...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final infoPlistPath = p.join(rootPath, 'ios', 'Runner', 'Info.plist');
    final infoPlistFile = File(infoPlistPath);

    if (!infoPlistFile.existsSync()) {
      throw Exception('Info.plist not found at $infoPlistPath');
    }

    String content = infoPlistFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'<key>CFBundleDisplayName<\/key>\s*<string>([^<]*)<\/string>'),
      (match) => '<key>CFBundleDisplayName</key>\n\t<string>$newName</string>',
    );

    infoPlistFile.writeAsStringSync(content);
    _log('Updated Info.plist', type: LogType.success);
  }

  static void updateWindowsRC(String newName) {
    _log('Updating Runner.rc...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final windowsRCPath = p.join(rootPath, 'windows', 'runner', 'Runner.rc');
    final windowsRCFile = File(windowsRCPath);

    if (!windowsRCFile.existsSync()) {
      throw Exception('Runner.rc not found at $windowsRCPath');
    }

    String content = windowsRCFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'VALUE "ProductName", "([^"]*)"'),
      (match) => 'VALUE "ProductName", "$newName"',
    );

    windowsRCFile.writeAsStringSync(content);
    _log('Updated Runner.rc', type: LogType.success);
  }

  static void copyIconToAndroidResource(String sourcePath) {
    _log('Copying icon to Android resources...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final destinationDir = p.join(
      rootPath,
      'android',
      'app',
      'src',
      'main',
      'res',
    );
    final file = File(sourcePath);
    if (!file.existsSync()) {
      throw Exception('Icon file not found at $sourcePath');
    }
    // copy to mipmap-hdpi
    _log('Copying to mipmap-hdpi...', type: LogType.progress);
    final hdpiDestinationPath = p.join(
      destinationDir,
      "mipmap-hdpi",
      "ic_launcher.png",
    );
    copyIconTo(file, hdpiDestinationPath);
    // copy to mipmap-mdpi
    _log('Copying to mipmap-mdpi...', type: LogType.progress);
    final mdpiDestinationPath = p.join(
      destinationDir,
      "mipmap-mdpi",
      "ic_launcher.png",
    );
    copyIconTo(file, mdpiDestinationPath);
    // copy to mipmap-xhdpi
    _log('Copying to mipmap-xhdpi...', type: LogType.progress);
    final xhdpiDestinationPath = p.join(
      destinationDir,
      "mipmap-xhdpi",
      "ic_launcher.png",
    );
    copyIconTo(file, xhdpiDestinationPath);
    // copy to mipmap-xxhdpi
    _log('Copying to mipmap-xxhdpi...', type: LogType.progress);
    final xxhdpiDestinationPath = p.join(
      destinationDir,
      "mipmap-xxhdpi",
      "ic_launcher.png",
    );
    copyIconTo(file, xxhdpiDestinationPath);
    // copy to mipmap-xxxhdpi
    _log('Copying to mipmap-xxxhdpi...', type: LogType.progress);
    final xxxhdpiDestinationPath = p.join(
      destinationDir,
      "mipmap-xxxhdpi",
      "ic_launcher.png",
    );
    copyIconTo(file, xxxhdpiDestinationPath);

    _log('Copied icon to Android resources', type: LogType.success);
  }

  static void copyIconToIOSResource(String sourcePath) {
    _log('Copying icon to IOS resources...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final destinationDir = p.join(
      rootPath,
      'ios',
      'Runner',
      'Assets.xcassets',
      'AppIcon.appiconset',
    );
    final file = File(sourcePath);
    if (!file.existsSync()) {
      throw Exception('Icon file not found at $sourcePath');
    }

    // copy icon to Contents.json
    _log('Updating Contents.json...', type: LogType.progress);
    File contentFile = File(p.join(destinationDir, "Contents.json"));
    String content = contentFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'"filename" : "([^"]+)"'),
      (match) => '"filename" : "${p.basename(file.path)}"',
    );
    contentFile.writeAsStringSync(content);

    _log('Copying to AppIcon.appiconset...', type: LogType.progress);
    copyIconTo(file, p.join(destinationDir, p.basename(file.path)));
    _log('Copied icon to IOS resources', type: LogType.success);
  }

  static void copyIconToWindowsResource(String sourcePath) {
    _log('Copying icon to Windows resources...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final destinationPath = p.join(
      rootPath,
      'windows',
      'runner',
      'resources',
      'app_icon.ico',
    );
    final file = File(sourcePath);
    if (!file.existsSync()) {
      throw Exception('Icon file not found at $sourcePath');
    }
    copyIconTo(file, destinationPath);
    _log('Copied icon to Windows resources', type: LogType.success);
  }

  static void copyIconTo(File file, String destination) {
    file.copySync(destination);
  }

  static void updateAndroidManifestIcon() {
    _log('Updating AndroidManifest.xml icon...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final androidManifestPath = p.join(
      rootPath,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );
    final manifestFile = File(androidManifestPath);
    if (!manifestFile.existsSync()) {
      throw Exception('AndroidManifest.xml not found at $androidManifestPath');
    }
    String content = manifestFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'android:icon="([^"]*)"'),
      (match) => 'android:icon="@mipmap/ic_launcher"',
    );

    manifestFile.writeAsStringSync(content);
    _log('Updated AndroidManifest.xml icon', type: LogType.success);
  }

  static void updateInfoPlistIcon() {
    _log('Updating Info.plist icon...', type: LogType.progress);
    final rootPath = getProjectRoot();
    final infoPlistPath = p.join(rootPath, 'ios', 'Runner', 'Info.plist');
    final infoPlistFile = File(infoPlistPath);

    if (!infoPlistFile.existsSync()) {
      throw Exception('Info.plist not found at $infoPlistPath');
    }

    String content = infoPlistFile.readAsStringSync();
    content = content.replaceAllMapped(
      RegExp(r'<key>CFBundleIconName<\/key>\s*<string>([^<]*)<\/string>'),
      (match) => '<key>CFBundleIconName</key>\n\t<string>AppIcon</string>',
    );

    infoPlistFile.writeAsStringSync(content);
    _log('Updated Info.plist icon', type: LogType.success);
  }

  // New function to log a message with a specific type.
  static void log(String message, {LogType type = LogType.info}) {
    _log(message, type: type);
  }

  static void showIntroduction() {
    // ASCII art for "BrandForge"
    final brandForgeArt = '''
     ____                      _ ______                   
    |  _ \                    | |  ____|                  
    | |_) |_ __ __ _ _ __   __| | |__ ___  _ __ __ _  ___ 
    |  _ <| '__/ _` | '_ \ / _` |  __/ _ \| '__/ _` |/ _ \
    | |_) | | | (_| | | | | (_| | | | (_) | | | (_| |  __/
    |____/|_|  \__,_|_| |_|\__,_|_|  \___/|_|  \__, |\___|
                                                __/ |     
                                                |___/
    ''';
    _log(brandForgeArt, type: LogType.info);
    _log('Welcome to BrandForge! 🎉', type: LogType.info);
    _log(
      'This tool helps you dynamically change your app\'s name and icon.',
      type: LogType.info,
    );
    _log('Use --help to see available commands.', type: LogType.info);
  }

  // Private helper method to log messages with prefixes.
  static void _log(String message, {LogType type = LogType.info}) {
    if (!kDebugMode) {
      return; // Don't print in release mode
    }
    String prefix = '';
    String emoji = '';
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
    // ignore: avoid_print
    print('$prefix $emoji $message');
  }
}

enum LogType { info, progress, success, error }
