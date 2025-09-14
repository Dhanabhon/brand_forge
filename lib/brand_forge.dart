import 'dart:io';

import 'package:brand_forge/errors/brand_forge_exception.dart';
import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:brand_forge/services/backup_service.dart';
import 'package:brand_forge/services/logging_service.dart';
import 'package:brand_forge/services/validation_service.dart';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

class BrandForge {
  static void showIntroduction() {
    LoggingService.printIntroduction();
  }

  /// Sets verbose mode for detailed logging
  static void setVerboseMode(bool verbose) {
    LoggingService.setVerboseMode(verbose);
    BackupService.setVerboseLogging(verbose);
  }

  static void changeAppName(ForgePlatform platform, String newName) {
    // Validate input
    ValidationService.validateAppName(newName);

    LoggingService.logOperationStart('App name change', platform.name);

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
      LoggingService.logOperationComplete('App name change', platform.name);
    } catch (e) {
      LoggingService.logOperationError(
        'App name change',
        platform.name,
        e.toString(),
      );
      rethrow;
    }
  }

  static void changeAppIcon(ForgePlatform platform, String iconPath) {
    // Validate icon file
    ValidationService.validateIconFile(iconPath);

    LoggingService.logOperationStart('App icon change', platform.name);

    try {
      switch (platform) {
        case ForgePlatform.iOS:
          _changeAppIconIOS(iconPath);
          break;
        case ForgePlatform.android:
          _changeAppIconAndroid(iconPath);
          break;
        case ForgePlatform.windows:
        case ForgePlatform.macOS:
        case ForgePlatform.linux:
          throw BrandForgeException.platformNotSupported(
            platform.name,
            'App icon change',
          );
      }
      LoggingService.logOperationComplete('App icon change', platform.name);
    } catch (e) {
      if (e is BrandForgeException &&
          e.type == BrandForgeErrorType.platformNotSupported) {
        LoggingService.logOperationWarning(
          'App icon change',
          platform.name,
          e.message,
        );
        return;
      }
      LoggingService.logOperationError(
        'App icon change',
        platform.name,
        e.toString(),
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

    ValidationService.validateRequiredFile(infoPlistPath, 'iOS');

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
      LoggingService.success('iOS app name updated to "$newName"');
    } catch (e) {
      throw BrandForgeException(
        'Failed to update iOS Info.plist',
        solution:
            'Check file permissions and ensure the Info.plist format is valid',
        type: BrandForgeErrorType.filePermission,
        filePath: infoPlistPath,
        innerException: e is Exception ? e : Exception(e.toString()),
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

    ValidationService.validateRequiredFile(manifestPath, 'Android');

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
      LoggingService.success('Android app name updated to "$newName"');
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Android AndroidManifest.xml',
        solution:
            'Check file permissions and ensure the AndroidManifest.xml format is valid',
        type: BrandForgeErrorType.filePermission,
        filePath: manifestPath,
        innerException: e is Exception ? e : Exception(e.toString()),
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

    ValidationService.validateRequiredFile(mainCppPath, 'Windows');

    try {
      String content = mainCppFile.readAsStringSync();

      // Create backup
      _createBackup(mainCppFile);

      content = content.replaceAllMapped(
        RegExp(r'!window\.Create\(L"(.*?)"'),
        (match) => '!window.Create(L"$newName"',
      );

      mainCppFile.writeAsStringSync(content);
      LoggingService.success('Windows app name updated to "$newName"');
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Windows main.cpp',
        solution:
            'Check file permissions and ensure the main.cpp format is valid',
        type: BrandForgeErrorType.filePermission,
        filePath: mainCppPath,
        innerException: e is Exception ? e : Exception(e.toString()),
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

    ValidationService.validateRequiredFile(infoPlistPath, 'macOS');

    try {
      String content = infoPlistFile.readAsStringSync();

      // Create backup
      _createBackup(infoPlistFile);

      content = content.replaceAll(
        RegExp(r'<key>CFBundleName</key>\s*<string>.*?</string>'),
        '<key>CFBundleName</key>\n\t<string>$newName</string>',
      );

      infoPlistFile.writeAsStringSync(content);
      LoggingService.success('macOS app name updated to "$newName"');
    } catch (e) {
      throw BrandForgeException(
        'Failed to update macOS Info.plist',
        solution:
            'Check file permissions and ensure the Info.plist format is valid',
        type: BrandForgeErrorType.filePermission,
        filePath: infoPlistPath,
        innerException: e is Exception ? e : Exception(e.toString()),
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

    ValidationService.validateRequiredFile(applicationPath, 'Linux');

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
      LoggingService.success('Linux app name updated to "$newName"');
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Linux my_application.cc',
        solution:
            'Check file permissions and ensure the my_application.cc format is valid',
        type: BrandForgeErrorType.filePermission,
        filePath: applicationPath,
        innerException: e is Exception ? e : Exception(e.toString()),
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

    ValidationService.validatePlatformDirectory(assetPath, 'iOS');

    try {
      // Create backup of existing icons
      _backupDirectory(assetDir);

      // Copy new icon to asset folder
      final String newIconPath = p.join(assetDir.path, 'icon.png');
      File(iconPath).copySync(newIconPath);
      LoggingService.success('iOS app icon updated.');
    } catch (e) {
      throw BrandForgeException(
        'Failed to update iOS app icon',
        solution:
            'Check file permissions and ensure the icon file is accessible',
        type: BrandForgeErrorType.filePermission,
        filePath: iconPath,
        innerException: e is Exception ? e : Exception(e.toString()),
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
    ValidationService.validatePlatformDirectory(mipmapPath, 'Android');

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
        LoggingService.success(
          'Android app icon updated in $copiedCount density folders.',
        );
      } else {
        LoggingService.warning(
          'No mipmap directories found for Android icon update.',
        );
      }
    } catch (e) {
      throw BrandForgeException(
        'Failed to update Android app icon',
        solution:
            'Check file permissions and ensure the icon file is accessible',
        type: BrandForgeErrorType.filePermission,
        filePath: iconPath,
        innerException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  static String _findProjectRoot() {
    return ValidationService.validateAndFindProjectRoot();
  }

  static void _createBackup(File file) {
    BackupService.createFileBackup(file);
  }

  static void _backupDirectory(Directory dir) {
    BackupService.createDirectoryBackup(dir);
  }
}
