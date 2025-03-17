import 'dart:io';

import 'package:args/args.dart';
import 'package:brand_forge/src/utils.dart';

void main(List<String> arguments) async {
  Utils.showIntroduction();
  final parser = ArgParser();

  // Name related
  parser.addOption('all-name', help: 'Change the app name for all platforms.');
  parser.addOption('ios-name', help: 'Change the app name for iOS.');
  parser.addOption('android-name', help: 'Change the app name for Android.');
  parser.addOption('windows-name', help: 'Change the app name for Windows.');

  // Icon related
  parser.addOption('all-icon', help: 'Change the app icon for all platforms.');
  parser.addOption('ios-icon', help: 'Change the app icon for iOS.');
  parser.addOption('android-icon', help: 'Change the app icon for Android.');
  parser.addOption('windows-icon', help: 'Change the app icon for Windows.');
  parser.addOption('icon-asset', help: 'Change the app icon from an asset.');
  parser.addOption('icon-file', help: 'Change the app icon from a file.');
  parser.addOption('icon-url', help: 'Change the app icon from a URL.');

  final argResults = parser.parse(arguments);

  if (argResults.wasParsed('all-name')) {
    final newName = argResults['all-name'] as String;
    Utils.log(
      'Changing app name to "$newName" for all platforms...',
      type: LogType.progress,
    );
    Utils.updateAndroidManifest(newName);
    Utils.updateInfoPlist(newName);
    Utils.updateWindowsRC(newName);
    Utils.log(
      'Changed app name to "$newName" for all platforms',
      type: LogType.success,
    );
  } else {
    final iosName = argResults['ios-name'] as String?;
    final androidName = argResults['android-name'] as String?;
    final windowsName = argResults['windows-name'] as String?;

    if (iosName != null) {
      Utils.log(
        'Changing iOS app name to "$iosName"...',
        type: LogType.progress,
      );
      Utils.updateInfoPlist(iosName);
      Utils.log('Changed iOS app name to "$iosName"', type: LogType.success);
    }
    if (androidName != null) {
      Utils.log(
        'Changing Android app name to "$androidName"...',
        type: LogType.progress,
      );
      Utils.updateAndroidManifest(androidName);
      Utils.log(
        'Changed Android app name to "$androidName"',
        type: LogType.success,
      );
    }
    if (windowsName != null) {
      Utils.log(
        'Changing Windows app name to "$windowsName"...',
        type: LogType.progress,
      );
      Utils.updateWindowsRC(windowsName);
      Utils.log(
        'Changed Windows app name to "$windowsName"',
        type: LogType.success,
      );
    }
  }

  if (argResults.wasParsed('all-icon')) {
    final filePath = _getIconPath(argResults);
    Utils.log('Changing app icon for all platforms...', type: LogType.progress);
    Utils.copyIconToAndroidResource(filePath);
    Utils.copyIconToIOSResource(filePath);
    Utils.copyIconToWindowsResource(filePath);
    Utils.updateAndroidManifestIcon();
    Utils.updateInfoPlistIcon();
    Utils.log('Changed app icon for all platforms', type: LogType.success);
  } else {
    final iosIcon = argResults['ios-icon'] as String?;
    final androidIcon = argResults['android-icon'] as String?;
    final windowsIcon = argResults['windows-icon'] as String?;
    if (iosIcon != null) {
      Utils.log('Changing iOS app icon...', type: LogType.progress);
      Utils.copyIconToIOSResource(_getIconPath(argResults));
      Utils.updateInfoPlistIcon();
      Utils.log('Changed iOS app icon', type: LogType.success);
    }
    if (androidIcon != null) {
      Utils.log('Changing Android app icon...', type: LogType.progress);
      Utils.copyIconToAndroidResource(_getIconPath(argResults));
      Utils.updateAndroidManifestIcon();
      Utils.log('Changed Android app icon', type: LogType.success);
    }
    if (windowsIcon != null) {
      Utils.log('Changing Windows app icon...', type: LogType.progress);
      Utils.copyIconToWindowsResource(_getIconPath(argResults));
      Utils.log('Changed Windows app icon', type: LogType.success);
    }
  }
  exit(0);
}

String _getIconPath(ArgResults argResults) {
  final iconAssetPath = argResults['icon-asset'] as String?;
  final iconFilePath = argResults['icon-file'] as String?;
  final iconUrl = argResults['icon-url'] as String?;
  if (iconAssetPath != null) {
    // TODO: handle icon from asset.
    throw UnimplementedError('Icon from asset is not implemented yet.');
  } else if (iconFilePath != null) {
    return iconFilePath;
  } else if (iconUrl != null) {
    // TODO: handle icon from url.
    throw UnimplementedError('Icon from url is not implemented yet.');
  } else {
    throw Exception('Please provide icon path.');
  }
}
