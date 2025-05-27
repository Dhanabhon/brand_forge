import 'package:args/args.dart';
import 'package:brand_forge/brand_forge.dart';
import 'package:brand_forge/helpers/platform_helper.dart';

void main(List<String> arguments) {
  BrandForge.showIntroduction();

  final parser =
      ArgParser()
        ..addOption('ios-name', help: 'Change the app name for iOS.')
        ..addOption('android-name', help: 'Change the app name for Android.')
        ..addOption('windows-name', help: 'Change the app name for Windows.')
        ..addOption('macos-name', help: 'Change the app name for macOS.')
        ..addOption('linux-name', help: 'Change the app name for Linux.')
        ..addOption(
          'all-name',
          help:
              'Change the app name for all supported platforms (iOS, Android, macOS, Windows, Linux).',
        )
        ..addOption(
          'ios-icon',
          help:
              'Change the app icon for iOS. Provide the path to a .png image.',
        )
        ..addOption(
          'android-icon',
          help:
              'Change the app icon for Android. Provide the path to a .png image.',
        )
        ..addOption(
          'all-icon',
          help:
              'Change the app icon for all supported platforms (iOS, Android, macOS, Windows, Linux). Provide the path to a .png image.',
        )
        ..addFlag(
          'help',
          abbr: 'h',
          negatable: false,
          help: 'Displays this help message.',
        );

  final argResults = parser.parse(arguments);

  if (argResults['help'] == true) {
    // ignore: avoid_print
    print(parser.usage); // Show usage when --help or -h
    return;
  }

  // Handle App Name Changes
  if (argResults['ios-name'] != null) {
    BrandForge.changeAppName(ForgePlatform.iOS, argResults['ios-name']!);
  } else if (argResults['android-name'] != null) {
    BrandForge.changeAppName(
      ForgePlatform.android,
      argResults['android-name']!,
    );
  } else if (argResults['windows-name'] != null) {
    BrandForge.changeAppName(
      ForgePlatform.windows,
      argResults['windows-name']!,
    );
  } else if (argResults['macos-name'] != null) {
    BrandForge.changeAppName(ForgePlatform.macOS, argResults['macos-name']!);
  } else if (argResults['linux-name'] != null) {
    BrandForge.changeAppName(ForgePlatform.linux, argResults['linux-name']!);
  } else if (argResults['all-name'] != null) {
    final allName = argResults['all-name']!;
    BrandForge.changeAppName(ForgePlatform.iOS, allName);
    BrandForge.changeAppName(ForgePlatform.android, allName);
    BrandForge.changeAppName(ForgePlatform.windows, allName);
    BrandForge.changeAppName(ForgePlatform.macOS, allName);
    BrandForge.changeAppName(ForgePlatform.linux, allName);
  }

  // Handle App Icon Changes
  if (argResults['ios-icon'] != null) {
    BrandForge.changeAppIcon(ForgePlatform.iOS, argResults['ios-icon']!);
  } else if (argResults['android-icon'] != null) {
    BrandForge.changeAppIcon(
      ForgePlatform.android,
      argResults['android-icon']!,
    );
  } else if (argResults['all-icon'] != null) {
    final allIcon = argResults['all-icon']!;
    BrandForge.changeAppIcon(ForgePlatform.iOS, allIcon);
    BrandForge.changeAppIcon(ForgePlatform.android, allIcon);
    // BrandForge.changeAppIcon(ForgePlatform.macOS, allIcon);
    // BrandForge.changeAppIcon(ForgePlatform.windows, allIcon);
    // BrandForge.changeAppIcon(ForgePlatform.linux, allIcon);
  }
}
