import 'package:args/args.dart';
import 'package:brand_forge/brand_forge.dart';

void main(List<String> arguments) {
  BrandForge.showIntroduction(); // Show the introduction!

  final parser =
      ArgParser()
        ..addOption('ios_name')
        ..addOption('android_name')
        ..addOption('all_name')
        ..addOption('ios_icon')
        ..addOption('android_icon')
        ..addOption('all_icon')
        ..addFlag('help', abbr: 'h', negatable: false); //add help flag

  final argResults = parser.parse(arguments);

  if (argResults['help'] == true) {
    // ignore: avoid_print
    print(parser.usage); //show usage when --help or -h
    return;
  }

  // Handle App Name Changes
  if (argResults['ios_name'] != null) {
    BrandForge.changeAppName(Platform.iOS, argResults['ios_name']!);
  }
  if (argResults['android_name'] != null) {
    BrandForge.changeAppName(Platform.android, argResults['android_name']!);
  }
  if (argResults['all_name'] != null) {
    BrandForge.changeAppName(Platform.iOS, argResults['all_name']!);
    BrandForge.changeAppName(Platform.android, argResults['all_name']!);
    BrandForge.changeAppName(Platform.macOS, argResults['all_name']!);
    BrandForge.changeAppName(Platform.windows, argResults['all_name']!);
    BrandForge.changeAppName(Platform.linux, argResults['all_name']!);
  }

  // Handle App Icon Changes
  if (argResults['ios_icon'] != null) {
    BrandForge.changeAppIcon(Platform.iOS, argResults['ios_icon']!);
  }
  if (argResults['android_icon'] != null) {
    BrandForge.changeAppIcon(Platform.android, argResults['android_icon']!);
  }
  if (argResults['all_icon'] != null) {
    BrandForge.changeAppIcon(Platform.iOS, argResults['all_icon']!);
    BrandForge.changeAppIcon(Platform.android, argResults['all_icon']!);
    BrandForge.changeAppIcon(Platform.macOS, argResults['all_icon']!);
    BrandForge.changeAppIcon(Platform.windows, argResults['all_icon']!);
    BrandForge.changeAppIcon(Platform.linux, argResults['all_icon']!);
  }
}
