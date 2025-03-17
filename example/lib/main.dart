import 'dart:io';

import 'package:brand_forge/brand_forge.dart';

void main(List<String> arguments) async {
  print('Welcome to BrandForge Example');
  Utils.showIntroduction();
  // Example usage
  if (arguments.isNotEmpty) {
    if(arguments.contains("--name")){
      final index = arguments.indexOf("--name");
      if(index < arguments.length -1){
        final name = arguments[index + 1];
        Utils.log('Updating app name to $name', type: LogType.progress);
        Utils.updateAndroidManifest(name);
        Utils.updateInfoPlist(name);
        Utils.updateWindowsRC(name);
        Utils.log('Update name to $name complete', type: LogType.success);
      }else {
        Utils.log('Please provide name when using --name', type: LogType.error);
      }
    }
    if(arguments.contains("--icon")){
      final index = arguments.indexOf("--icon");
      if(index < arguments.length -1){
        final iconPath = arguments[index + 1];
        Utils.log('Updating app icon to $iconPath', type: LogType.progress);
        Utils.copyIconToAndroidResource(iconPath);
        Utils.copyIconToIOSResource(iconPath);
        Utils.copyIconToWindowsResource(iconPath);
        Utils.updateAndroidManifestIcon();
        Utils.updateInfoPlistIcon();
        Utils.log('Update icon to $iconPath complete', type: LogType.success);
      }else{
        Utils.log('Please provide icon path when using --icon', type: LogType.error);
      }
    }

  } else {
      Utils.log('Please provide argument', type: LogType.error);
      Utils.log('Example: dart run --name YourName --icon path/to/your/icon.png', type: LogType.info);
  }
    exit(0);
}
