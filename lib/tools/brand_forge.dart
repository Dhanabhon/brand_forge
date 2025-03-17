import 'dart:io';

import 'package:args/args.dart';
import 'package:brand_forge/src/icon_changer.dart';
import 'package:brand_forge/src/name_changer.dart';
import 'package:flutter/foundation.dart';

void main(List<String> arguments) async {
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
  parser.addOption(
    'icon-asset',
    help: 'Change the app icon from an asset.',
  );
  parser.addOption(
    'icon-file',
    help: 'Change the app icon from a file.',
  );
  parser.addOption(
    'icon-url',
    help: 'Change the app icon from a URL.',
  );

  final argResults = parser.parse(arguments);

  final nameChanger = NameChanger();
  final iconChanger = IconChanger();

  if (argResults.wasParsed('all')) {
    final newName = argResults['all'] as String;
    if (kDebugMode) {
      print('Changing app name to "$newName" for all platforms...');
    }
    await _changeNameForAllPlatforms(newName, nameChanger);
  } else {
    final iosName = argResults['ios'] as String?;
    final androidName = argResults['android'] as String?;
    final windowsName = argResults['windows'] as String?;

    if (iosName != null) {
      if (kDebugMode) {
        print('Changing iOS app name to "$iosName"...');
      }
      await nameChanger.setAppName(iosName);
    }
    if (androidName != null) {
      if (kDebugMode) {
        print('Changing Android app name to "$androidName"...');
      }
      await nameChanger.setAppName(androidName);
    }
    if (windowsName != null) {
      if (kDebugMode) {
        print('Changing Windows app name to "$windowsName"...');
      }
      await nameChanger.setAppName(windowsName);
    }
  }

  if (argResults.wasParsed('all-icon')) {
    final assetPath = argResults['icon-asset'] as String?;
    final filePath = argResults['icon-file'] as String?;
    final url = argResults['icon-url'] as String?;
    if (kDebugMode) {
      print('Changing app icon for all platforms...');
    }
    await _changeIconForAllPlatforms(assetPath, filePath, url, iconChanger);
  } else {
    final iosIcon = argResults['ios-icon'] as String?;
    final androidIcon = argResults['android-icon'] as String?;
    final windowsIcon = argResults['windows-icon'] as String?;
    final iconAssetPath = argResults['icon-asset'] as String?;
    final iconFilePath = argResults['icon-file'] as String?;
    final iconUrl = argResults['icon-url'] as String?;
    if (iosIcon != null) {
      if (kDebugMode) {
        print('Changing iOS app icon...');
      }
      await _changeIconForPlatform(
          iosIcon, iconAssetPath, iconFilePath, iconUrl, iconChanger);
    }
    if (androidIcon != null) {
      if (kDebugMode) {
        print('Changing Android app icon...');
      }
      await _changeIconForPlatform(
          androidIcon, iconAssetPath, iconFilePath, iconUrl, iconChanger);
    }
    if (windowsIcon != null) {
      if (kDebugMode) {
        print('Changing Windows app icon...');
      }
      await _changeIconForPlatform(
          windowsIcon, iconAssetPath, iconFilePath, iconUrl, iconChanger);
    }
  }
  exit(0);
}

Future<void> _changeNameForAllPlatforms(
    String newName, NameChanger nameChanger) async {
  await nameChanger.setAppName(newName);
}

Future<void> _changeIconForAllPlatforms(String? assetPath, String? filePath,
    String? url, IconChanger iconChanger) async {
  await _changeIconForPlatform('all', assetPath, filePath, url, iconChanger);
}

Future<void> _changeIconForPlatform(String? platform, String? assetPath,
    String? filePath, String? url, IconChanger iconChanger) async {
  if (assetPath != null) {
    await iconChanger.setIconFromAsset(assetPath);
  }
  if (filePath != null) {
    final file = File(filePath);
    await iconChanger.setIconFromFile(file);
  }
  if (url != null) {
    await iconChanger.setIconFromUrl(url);
  }
}
