import 'dart:io';

import 'package:brand_forge/errors/brand_forge_exception.dart';
import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

enum LogType { info, progress, success, error, warning }

class BrandForge {
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

  static void changeAppName(ForgePlatform platform, String newName) {
    // Validate input
    _validateAppName(newName);

    _log(
      'Changing app name for ${platform.name} to "$newName"...',
      type: LogType.progress,
    );

    try {
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
    } catch (e) {
      _log(
        'Failed to change app name for ${platform.name}: $e',
        type: LogType.error,
      );
      rethrow;
    }
  }

  static void changeAppIcon(ForgePlatform platform, String iconPath) {
    // Validate icon file
    _validateIconFile(iconPath);

    _log(
      'Changing app icon for ${platform.name} using $iconPath...',
      type: LogType.progress,
    );

    try {
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
            type: LogType.warning,
          );
          break;
        case ForgePlatform.macOS:
          _log(
            'macOS app icon change not yet implemented.',
            type: LogType.warning,
          );
          break;
        case ForgePlatform.linux:
          _log(
            'Linux app icon change not yet implemented.',
            type: LogType.warning,
          );
          break;
      }
    } catch (e) {
      _log(
        'Failed to change app icon for ${platform.name}: $e',
        type: LogType.error,
      );
      rethrow;
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
      throw BrandForgeException(
        'iOS Info.plist not found at: $infoPlistPath',
        'Ensure you are running this command from a Flutter project root directory with iOS support',
      );
    }

    try {
      String content = infoPlistFile.readAsStringSync();

      // Create backup
      _createBackup(infoPlistFile);

      content = content.replaceAll(
        RegExp(r'<key>CFBundleDisplayName</key>\s*<string>.*?</string>'),
        '<key>CFBundleDisplayName</key>\n\t<string>$newName</string>',
      );
      content = content.replaceAll(
        RegExp(r'<key>CFBundleName</key>\s*<string>.*?</string>'),
        '<key>CFBundleName</key>\n\t<string>$newName</string>',
      );

      infoPlistFile.writeAsStringSync(content);
      _log('iOS app name updated to "$newName"', type: LogType.success);
    } catch (e) {
      throw BrandForgeException(
        'Failed to update iOS Info.plist: $e',
        'Check file permissions and ensure the Info.plist format is valid',
      );
    }
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
      throw BrandForgeException(
        'Android AndroidManifest.xml not found at: $manifestPath',
        'Ensure you are running this command from a Flutter project root directory with Android support',
      );
    }

    try {
      // Create backup
      _createBackup(manifestFile);

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
        document.toXmlString(pretty: true, indent: '    '),
      );
      _log('Android app name updated to "$newName"', type: LogType.success);
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Android AndroidManifest.xml: $e',
        'Check file permissions and ensure the AndroidManifest.xml format is valid',
      );
    }
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
      throw BrandForgeException(
        'Windows main.cpp file not found at: $mainCppPath',
        'Ensure you are running this command from a Flutter project root directory with Windows support',
      );
    }

    try {
      String content = mainCppFile.readAsStringSync();

      // Create backup
      _createBackup(mainCppFile);

      content = content.replaceAllMapped(
        RegExp(r'!window\.Create\(L"(.*?)"'),
        (match) => '!window.Create(L"$newName"',
      );

      mainCppFile.writeAsStringSync(content);
      _log('Windows app name updated to "$newName"', type: LogType.success);
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Windows main.cpp: $e',
        'Check file permissions and ensure the main.cpp format is valid',
      );
    }
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
      throw BrandForgeException(
        'macOS Info.plist not found at: $infoPlistPath',
        'Ensure you are running this command from a Flutter project root directory with macOS support',
      );
    }

    try {
      String content = infoPlistFile.readAsStringSync();

      // Create backup
      _createBackup(infoPlistFile);

      content = content.replaceAll(
        RegExp(r'<key>CFBundleName</key>\s*<string>.*?</string>'),
        '<key>CFBundleName</key>\n\t<string>$newName</string>',
      );

      infoPlistFile.writeAsStringSync(content);
      _log('macOS app name updated to "$newName"', type: LogType.success);
    } catch (e) {
      throw BrandForgeException(
        'Failed to update macOS Info.plist: $e',
        'Check file permissions and ensure the Info.plist format is valid',
      );
    }
  }

  static void _changeAppNameLinux(String newName) {
    final String projectRoot = _findProjectRoot();
    final String applicationPath = p.join(
      projectRoot,
      'linux',
      'runner',
      'my_application.cc',
    );
    final File applicationFile = File(applicationPath);

    if (!applicationFile.existsSync()) {
      throw BrandForgeException(
        'Linux my_application.cc file not found at: $applicationPath',
        'Ensure you are running this command from a Flutter project root directory with Linux support',
      );
    }

    try {
      String content = applicationFile.readAsStringSync();

      // Create backup
      _createBackup(applicationFile);

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
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Linux my_application.cc: $e',
        'Check file permissions and ensure the my_application.cc format is valid',
      );
    }
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
      throw BrandForgeException(
        'iOS Asset directory not found at: $assetPath',
        'Ensure you are running this command from a Flutter project root directory with iOS support',
      );
    }

    try {
      // Create backup of existing icons
      _backupDirectory(assetDir);

      // Copy new icon to asset folder
      final String newIconPath = p.join(assetDir.path, 'icon.png');
      File(iconPath).copySync(newIconPath);
      _log('iOS app icon updated.', type: LogType.success);
    } catch (e) {
      throw BrandForgeException(
        'Failed to update iOS app icon: $e',
        'Check file permissions and ensure the icon file is accessible',
      );
    }
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
      throw BrandForgeException(
        'Android mipmap directory not found at: $mipmapPath',
        'Ensure you are running this command from a Flutter project root directory with Android support',
      );
    }

    try {
      // Copy new icon to mipmap folder
      final List<String> densities = [
        'mipmap-mdpi',
        'mipmap-hdpi',
        'mipmap-xhdpi',
        'mipmap-xxhdpi',
        'mipmap-xxxhdpi',
      ];

      int copiedCount = 0;
      for (var density in densities) {
        final String destDir = p.join(mipmapPath, density);
        if (Directory(destDir).existsSync()) {
          final String newIconPath = p.join(destDir, 'ic_launcher.png');

          // Create backup of existing icon
          if (File(newIconPath).existsSync()) {
            _createBackup(File(newIconPath));
          }

          File(iconPath).copySync(newIconPath);
          copiedCount++;
        }
      }

      if (copiedCount > 0) {
        _log(
          'Android app icon updated in $copiedCount density folders.',
          type: LogType.success,
        );
      } else {
        _log(
          'No mipmap directories found for Android icon update.',
          type: LogType.warning,
        );
      }
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Android app icon: $e',
        'Check file permissions and ensure the icon file is accessible',
      );
    }
  }

  static String _findProjectRoot() {
    Directory current = Directory.current;
    while (current.path != current.parent.path) {
      if (File(p.join(current.path, 'pubspec.yaml')).existsSync()) {
        return current.path;
      }
      current = current.parent;
    }
    throw const BrandForgeException(
      'Could not find Flutter project root directory',
      'Ensure you are running this command from within a Flutter project directory',
    );
  }

  static void _createBackup(File file) {
    if (!file.existsSync()) return;

    final backupPath =
        '${file.path}.backup.${DateTime.now().millisecondsSinceEpoch}';
    try {
      file.copySync(backupPath);
      _log('Created backup: $backupPath', type: LogType.info);
    } catch (e) {
      _log(
        'Warning: Could not create backup for ${file.path}: $e',
        type: LogType.warning,
      );
    }
  }

  static void _backupDirectory(Directory dir) {
    if (!dir.existsSync()) return;

    final backupPath =
        '${dir.path}.backup.${DateTime.now().millisecondsSinceEpoch}';
    try {
      _copyDirectory(dir, Directory(backupPath));
      _log('Created directory backup: $backupPath', type: LogType.info);
    } catch (e) {
      _log(
        'Warning: Could not create directory backup for ${dir.path}: $e',
        type: LogType.warning,
      );
    }
  }

  static void _copyDirectory(Directory source, Directory destination) {
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }

    source.listSync().forEach((entity) {
      final String newPath = p.join(destination.path, p.basename(entity.path));
      if (entity is File) {
        entity.copySync(newPath);
      } else if (entity is Directory) {
        _copyDirectory(entity, Directory(newPath));
      }
    });
  }

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
          emoji = '⏳'; // Hourglass
          break;
        case LogType.success:
          prefix = '[SUCCESS]';
          emoji = '✅'; // Check mark
          break;
        case LogType.error:
          prefix = '[ERROR]';
          emoji = '❌'; // Cross mark
          break;
        case LogType.warning:
          prefix = '[WARNING]';
          emoji = '⚠️'; // Warning sign
          break;
      }
    }
    // ignore: avoid_print
    print(
      '$prefix$emoji $message',
    ); // Concatenate prefix and emoji only if needed
  }

  static void _validateAppName(String appName) {
    if (appName.trim().isEmpty) {
      throw const BrandForgeException(
        'App name cannot be empty',
        'Provide a valid app name with at least one character',
      );
    }

    if (appName.length > 100) {
      throw const BrandForgeException(
        'App name is too long (maximum 100 characters)',
        'Use a shorter app name',
      );
    }

    // Check for invalid characters in app names
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    if (invalidChars.hasMatch(appName)) {
      throw BrandForgeException(
        'App name contains invalid characters: ${invalidChars.allMatches(appName).map((e) => e.group(0)).join(", ")}',
        'Remove special characters like < > : " / \\ | ? *',
      );
    }
  }

  static void _validateIconFile(String iconPath) {
    final File iconFile = File(iconPath);

    if (!iconFile.existsSync()) {
      throw BrandForgeException(
        'Icon file not found at: $iconPath',
        'Check the file path and ensure the file exists',
      );
    }

    // Check file size (should not be too large)
    final fileSizeBytes = iconFile.lengthSync();
    const maxSizeBytes = 10 * 1024 * 1024; // 10MB

    if (fileSizeBytes > maxSizeBytes) {
      throw BrandForgeException(
        'Icon file is too large: ${(fileSizeBytes / 1024 / 1024).toStringAsFixed(1)}MB',
        'Use an icon file smaller than 10MB',
      );
    }

    // Check file extension
    final extension = p.extension(iconPath).toLowerCase();
    final validExtensions = ['.png', '.jpg', '.jpeg', '.ico'];

    if (!validExtensions.contains(extension)) {
      throw BrandForgeException(
        'Unsupported icon format: $extension',
        'Use one of these formats: ${validExtensions.join(", ")}',
      );
    }
  }
}
