import 'package:args/args.dart';
import 'package:brand_forge/brand_forge.dart';

void main(List<String> arguments) {
  BrandForge.showIntroduction();

  final parser =
      ArgParser()
        ..addOption('ios-name', help: 'Change the app name for iOS.')
        ..addOption('android-name', help: 'Change the app name for Android.')
        ..addOption('windows-name', help: 'Change the app name for Windows.')
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
    BrandForge.changeAppName(Platform.iOS, argResults['ios-name']!);
  } else if (argResults['android-name'] != null) {
    BrandForge.changeAppName(Platform.android, argResults['android-name']!);
  } else if (argResults['windows-name'] != null) {
    BrandForge.changeAppName(Platform.windows, argResults['windows-name']!);
  } else if (argResults['all-name'] != null) {
    final allName = argResults['all-name']!;
    BrandForge.changeAppName(Platform.iOS, allName);
    BrandForge.changeAppName(Platform.android, allName);
    // BrandForge.changeAppName(Platform.macOS, allName);
    // BrandForge.changeAppName(Platform.windows, allName);
    // BrandForge.changeAppName(Platform.linux, allName);
  }

  // Handle App Icon Changes
  if (argResults['ios-icon'] != null) {
    BrandForge.changeAppIcon(Platform.iOS, argResults['ios-icon']!);
  } else if (argResults['android-icon'] != null) {
    BrandForge.changeAppIcon(Platform.android, argResults['android-icon']!);
  } else if (argResults['all-icon'] != null) {
    final allIcon = argResults['all-icon']!;
    BrandForge.changeAppIcon(Platform.iOS, allIcon);
    BrandForge.changeAppIcon(Platform.android, allIcon);
    // BrandForge.changeAppIcon(Platform.macOS, allIcon);
    // BrandForge.changeAppIcon(Platform.windows, allIcon);
    // BrandForge.changeAppIcon(Platform.linux, allIcon);
  }
}
