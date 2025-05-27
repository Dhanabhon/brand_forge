import 'dart:io';

import 'package:args/args.dart';
import 'package:brand_forge/brand_forge.dart';
import 'package:brand_forge/helpers/platform_helper.dart';

void main(List<String> arguments) {
  BrandForge.showIntroduction();

  final parser =
      ArgParser()
        ..addOption('ios-name', help: 'Set iOS app name')
        ..addOption('android-name', help: 'Set Android app name')
        ..addOption('windows-name', help: 'Set Windows app name')
        ..addOption('macos-name', help: 'Set macOS app name')
        ..addOption('linux-name', help: 'Set Linux app name')
        ..addOption('all-name', help: 'Set app name for all platforms')
        ..addOption('ios-icon', help: 'Set iOS app icon (path to image file)')
        ..addOption(
          'android-icon',
          help: 'Set Android app icon (path to image file)',
        )
        ..addOption(
          'windows-icon',
          help: 'Set Windows app icon (path to image file)',
        )
        ..addOption(
          'macos-icon',
          help: 'Set macOS app icon (path to image file)',
        )
        ..addOption(
          'linux-icon',
          help: 'Set Linux app icon (path to image file)',
        )
        ..addOption('all-icon', help: 'Set app icon for all platforms')
        ..addFlag(
          'help',
          abbr: 'h',
          help: 'Show this help message',
          negatable: false,
        )
        ..addFlag(
          'version',
          abbr: 'v',
          help: 'Show version information',
          negatable: false,
        )
        ..addFlag('verbose', help: 'Enable verbose logging', negatable: false);

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _showHelp(parser);
      return;
    }

    if (results['version'] as bool) {
      _showVersion();
      return;
    }

    if (arguments.isEmpty) {
      BrandForge.showIntroduction();
      _showHelp(parser);
      return;
    }

    // Set verbose mode if requested
    final verbose = results['verbose'] as bool;

    _processCommands(results, verbose);
  } catch (e) {
    print('❌ Error: ${e.toString()}');
    print('Use --help for usage information.');
    exit(1);
  }
}

void _processCommands(ArgResults results, bool verbose) {
  bool hasAnyCommand = false;

  // Handle all-name command first
  if (results['all-name'] != null) {
    final appName = results['all-name'] as String;
    if (appName.isEmpty) {
      throw ArgumentError('App name cannot be empty');
    }

    _changeAppNameForAllPlatforms(appName, verbose);
    hasAnyCommand = true;
  }

  // Handle individual platform name changes
  final platformNames = {
    'ios-name': ForgePlatform.iOS,
    'android-name': ForgePlatform.android,
    'windows-name': ForgePlatform.windows,
    'macos-name': ForgePlatform.macOS,
    'linux-name': ForgePlatform.linux,
  };

  for (final entry in platformNames.entries) {
    final optionName = entry.key;
    final platform = entry.value;

    if (results[optionName] != null) {
      final appName = results[optionName] as String;
      if (appName.isEmpty) {
        throw ArgumentError('App name cannot be empty');
      }

      if (verbose) print('🔄 Processing $optionName...');
      BrandForge.changeAppName(platform, appName);
      hasAnyCommand = true;
    }
  }

  // Handle all-icon command
  if (results['all-icon'] != null) {
    final iconPath = results['all-icon'] as String;
    if (iconPath.isEmpty) {
      throw ArgumentError('Icon path cannot be empty');
    }

    _changeAppIconForAllPlatforms(iconPath, verbose);
    hasAnyCommand = true;
  }

  // Handle individual platform icon changes
  final platformIcons = {
    'ios-icon': ForgePlatform.iOS,
    'android-icon': ForgePlatform.android,
    'windows-icon': ForgePlatform.windows,
    'macos-icon': ForgePlatform.macOS,
    'linux-icon': ForgePlatform.linux,
  };

  for (final entry in platformIcons.entries) {
    final optionName = entry.key;
    final platform = entry.value;

    if (results[optionName] != null) {
      final iconPath = results[optionName] as String;
      if (iconPath.isEmpty) {
        throw ArgumentError('Icon path cannot be empty');
      }

      if (verbose) print('🔄 Processing $optionName...');
      BrandForge.changeAppIcon(platform, iconPath);
      hasAnyCommand = true;
    }
  }

  if (!hasAnyCommand) {
    print('❌ No valid commands provided.');
    print('Use --help for usage information.');
    exit(1);
  }
}

void _changeAppNameForAllPlatforms(String appName, bool verbose) {
  final platforms = [
    ForgePlatform.iOS,
    ForgePlatform.android,
    ForgePlatform.windows,
    ForgePlatform.macOS,
    ForgePlatform.linux,
  ];

  if (verbose) print('🔄 Changing app name for all platforms...');

  for (final platform in platforms) {
    try {
      BrandForge.changeAppName(platform, appName);
    } catch (e) {
      print('⚠️  Warning: Failed to change app name for ${platform.name}: $e');
    }
  }
}

void _changeAppIconForAllPlatforms(String iconPath, bool verbose) {
  final platforms = [
    ForgePlatform.iOS,
    ForgePlatform.android,
    ForgePlatform.windows,
    ForgePlatform.macOS,
    ForgePlatform.linux,
  ];

  if (verbose) print('🔄 Changing app icon for all platforms...');

  for (final platform in platforms) {
    try {
      BrandForge.changeAppIcon(platform, iconPath);
    } catch (e) {
      print('⚠️  Warning: Failed to change app icon for ${platform.name}: $e');
    }
  }
}

void _showHelp(ArgParser parser) {
  print('''
BrandForge - Dynamically Brand Your Flutter App

Usage: dart run brand_forge [options]

${parser.usage}

Examples:
  dart run brand_forge --ios-name "My App"
  dart run brand_forge --android-name "My App" --android-icon "icon.png"
  dart run brand_forge --all-name "My App"
  dart run brand_forge --all-icon "icon.png"
  dart run brand_forge --help
  dart run brand_forge --version

For more information, visit: https://github.com/Dhanabhon/brand_forge
''');
}

void _showVersion() {
  print('BrandForge version 0.0.4');
  print('A Flutter package to change app name and icon via command line.');
}
