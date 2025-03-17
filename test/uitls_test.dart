import 'dart:io';

import 'package:brand_forge/src/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('Utils', () {
    late Directory tempDir;
    late String tempPath;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('brand_forge_test');
      tempPath = tempDir.path;
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    group('getProjectRoot()', () {
      test('should find project root when pubspec.yaml exists', () {
        final pubspecFile = File(p.join(tempPath, 'pubspec.yaml'));
        pubspecFile.createSync();

        final projectRoot = Utils.getProjectRoot();
        expect(projectRoot, equals(tempPath));
      });

      test('should throw exception when pubspec.yaml does not exist', () {
        expect(() => Utils.getProjectRoot(), throwsException);
      });
    });

    group('updateAndroidManifest()', () {
      test('should update AndroidManifest.xml correctly', () {
        final manifestFile = File(
          p.join(
            tempPath,
            'android',
            'app',
            'src',
            'main',
            'AndroidManifest.xml',
          ),
        );
        manifestFile.parent.createSync(recursive: true);
        manifestFile.writeAsStringSync(
          '<?xml version="1.0" encoding="utf-8"?><manifest><application android:label="OldName"/></manifest>',
        );

        Utils.updateAndroidManifest('NewName');

        final content = manifestFile.readAsStringSync();
        expect(content, contains('android:label="NewName"'));
      });

      test('should throw exception when AndroidManifest.xml not found', () {
        expect(() => Utils.updateAndroidManifest('NewName'), throwsException);
      });
      test(
        'should throw exception when AndroidManifest.xml not well format',
        () {
          final manifestFile = File(
            p.join(
              tempPath,
              'android',
              'app',
              'src',
              'main',
              'AndroidManifest.xml',
            ),
          );
          manifestFile.parent.createSync(recursive: true);
          manifestFile.writeAsStringSync('some text');

          expect(() => Utils.updateAndroidManifest('NewName'), throwsException);
        },
      );
    });

    group('updateInfoPlist()', () {
      test('should update Info.plist correctly', () {
        final infoPlistFile = File(
          p.join(tempPath, 'ios', 'Runner', 'Info.plist'),
        );
        infoPlistFile.parent.createSync(recursive: true);
        infoPlistFile.writeAsStringSync('''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>OldName</string>
</dict>
</plist>
          ''');

        Utils.updateInfoPlist('NewName');

        final content = infoPlistFile.readAsStringSync();
        expect(content, contains('<string>NewName</string>'));
      });

      test('should throw exception when Info.plist not found', () {
        expect(() => Utils.updateInfoPlist('NewName'), throwsException);
      });
      test('should throw exception when Info.plist not well format', () {
        final infoPlistFile = File(
          p.join(tempPath, 'ios', 'Runner', 'Info.plist'),
        );
        infoPlistFile.parent.createSync(recursive: true);
        infoPlistFile.writeAsStringSync('some text');
        expect(() => Utils.updateInfoPlist('NewName'), throwsException);
      });
    });

    group('updateWindowsRC()', () {
      test('should update Runner.rc correctly', () {
        final windowsRCFile = File(
          p.join(tempPath, 'windows', 'runner', 'Runner.rc'),
        );
        windowsRCFile.parent.createSync(recursive: true);
        windowsRCFile.writeAsStringSync('VALUE "ProductName", "OldName"');

        Utils.updateWindowsRC('NewName');

        final content = windowsRCFile.readAsStringSync();
        expect(content, contains('VALUE "ProductName", "NewName"'));
      });

      test('should throw exception when Runner.rc not found', () {
        expect(() => Utils.updateWindowsRC('NewName'), throwsException);
      });
      test('should throw exception when Runner.rc not well format', () {
        final windowsRCFile = File(
          p.join(tempPath, 'windows', 'runner', 'Runner.rc'),
        );
        windowsRCFile.parent.createSync(recursive: true);
        windowsRCFile.writeAsStringSync('some text');
        expect(() => Utils.updateWindowsRC('NewName'), throwsException);
      });
    });

    group('copyIconToAndroidResource()', () {
      test('should copy icon to Android resources correctly', () {
        final sourceIconFile = File(p.join(tempPath, 'icon.png'));
        sourceIconFile.createSync();
        sourceIconFile.writeAsBytesSync([1, 2, 3]); // Dummy content

        Utils.copyIconToAndroidResource(sourceIconFile.path);

        final hdpiDestinationPath = p.join(
          tempPath,
          'android',
          'app',
          'src',
          'main',
          'res',
          "mipmap-hdpi",
          "ic_launcher.png",
        );
        final mdpiDestinationPath = p.join(
          tempPath,
          'android',
          'app',
          'src',
          'main',
          'res',
          "mipmap-mdpi",
          "ic_launcher.png",
        );
        final xhdpiDestinationPath = p.join(
          tempPath,
          'android',
          'app',
          'src',
          'main',
          'res',
          "mipmap-xhdpi",
          "ic_launcher.png",
        );
        final xxhdpiDestinationPath = p.join(
          tempPath,
          'android',
          'app',
          'src',
          'main',
          'res',
          "mipmap-xxhdpi",
          "ic_launcher.png",
        );
        final xxxhdpiDestinationPath = p.join(
          tempPath,
          'android',
          'app',
          'src',
          'main',
          'res',
          "mipmap-xxxhdpi",
          "ic_launcher.png",
        );

        expect(File(hdpiDestinationPath).existsSync(), isTrue);
        expect(File(mdpiDestinationPath).existsSync(), isTrue);
        expect(File(xhdpiDestinationPath).existsSync(), isTrue);
        expect(File(xxhdpiDestinationPath).existsSync(), isTrue);
        expect(File(xxxhdpiDestinationPath).existsSync(), isTrue);
      });

      test('should throw exception when source icon file not found', () {
        expect(
          () => Utils.copyIconToAndroidResource('nonexistent_icon.png'),
          throwsException,
        );
      });
    });

    group('copyIconToIOSResource()', () {
      test('should copy icon to IOS resources correctly', () {
        final sourceIconFile = File(p.join(tempPath, 'icon.png'));
        sourceIconFile.createSync();
        sourceIconFile.writeAsBytesSync([1, 2, 3]); // Dummy content

        Utils.copyIconToIOSResource(sourceIconFile.path);
        final destinationPath = p.join(
          tempPath,
          'ios',
          'Runner',
          'Assets.xcassets',
          'AppIcon.appiconset',
          'icon.png',
        );
        final contentsPath = p.join(
          tempPath,
          'ios',
          'Runner',
          'Assets.xcassets',
          'AppIcon.appiconset',
          'Contents.json',
        );

        expect(File(destinationPath).existsSync(), isTrue);
        expect(
          File(contentsPath).readAsStringSync(),
          contains('"filename" : "icon.png"'),
        );
      });

      test('should throw exception when source icon file not found', () {
        expect(
          () => Utils.copyIconToIOSResource('nonexistent_icon.png'),
          throwsException,
        );
      });
    });

    group('copyIconToWindowsResource()', () {
      test('should copy icon to Windows resources correctly', () {
        final sourceIconFile = File(p.join(tempPath, 'icon.ico'));
        sourceIconFile.createSync();
        sourceIconFile.writeAsBytesSync([1, 2, 3]); // Dummy content

        Utils.copyIconToWindowsResource(sourceIconFile.path);

        final destinationPath = p.join(
          tempPath,
          'windows',
          'runner',
          'resources',
          'app_icon.ico',
        );
        expect(File(destinationPath).existsSync(), isTrue);
      });

      test('should throw exception when source icon file not found', () {
        expect(
          () => Utils.copyIconToWindowsResource('nonexistent_icon.ico'),
          throwsException,
        );
      });
    });
    group('updateAndroidManifestIcon()', () {
      test('should update AndroidManifest.xml icon correctly', () {
        final manifestFile = File(
          p.join(
            tempPath,
            'android',
            'app',
            'src',
            'main',
            'AndroidManifest.xml',
          ),
        );
        manifestFile.parent.createSync(recursive: true);
        manifestFile.writeAsStringSync(
          '<?xml version="1.0" encoding="utf-8"?><manifest><application android:icon="@drawable/ic_launcher"/></manifest>',
        );
        Utils.updateAndroidManifestIcon();

        final content = manifestFile.readAsStringSync();
        expect(content, contains('android:icon="@mipmap/ic_launcher"'));
      });

      test('should throw exception when AndroidManifest.xml not found', () {
        expect(() => Utils.updateAndroidManifestIcon(), throwsException);
      });
      test(
        'should throw exception when AndroidManifest.xml not well format',
        () {
          final manifestFile = File(
            p.join(
              tempPath,
              'android',
              'app',
              'src',
              'main',
              'AndroidManifest.xml',
            ),
          );
          manifestFile.parent.createSync(recursive: true);
          manifestFile.writeAsStringSync('some text');

          expect(() => Utils.updateAndroidManifestIcon(), throwsException);
        },
      );
    });
    group('updateInfoPlistIcon()', () {
      test('should update Info.plist icon correctly', () {
        final infoPlistFile = File(
          p.join(tempPath, 'ios', 'Runner', 'Info.plist'),
        );
        infoPlistFile.parent.createSync(recursive: true);
        infoPlistFile.writeAsStringSync('''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIconName</key>
    <string>OldIcon</string>
</dict>
</plist>
          ''');

        Utils.updateInfoPlistIcon();

        final content = infoPlistFile.readAsStringSync();
        expect(content, contains('<string>AppIcon</string>'));
      });

      test('should throw exception when Info.plist not found', () {
        expect(() => Utils.updateInfoPlistIcon(), throwsException);
      });
      test('should throw exception when Info.plist not well format', () {
        final infoPlistFile = File(
          p.join(tempPath, 'ios', 'Runner', 'Info.plist'),
        );
        infoPlistFile.parent.createSync(recursive: true);
        infoPlistFile.writeAsStringSync('some text');
        expect(() => Utils.updateInfoPlistIcon(), throwsException);
      });
    });
    group('log()', () {
      test('should print log when kDebugMode is true', () {
        expect(kDebugMode, isTrue);
        Utils.log('test log', type: LogType.info);
      });
    });
  });
}
