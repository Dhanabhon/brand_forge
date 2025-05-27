import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brand_forge/brand_forge.dart';

void main() {
  group('BrandForge', () {
    test('changeAppName for iOS', () {
      // Arrange
      final platform = ForgePlatform.iOS;
      final newName = 'NewAppName';

      // Act
      BrandForge.changeAppName(platform, newName);

      // Assert
      // Add your assertions here to verify the app name change
    });

    test('changeAppName for Android', () {
      // Arrange
      final platform = ForgePlatform.android;
      final newName = 'NewAppName';

      // Act
      BrandForge.changeAppName(platform, newName);

      // Assert
      // Add your assertions here to verify the app name change
    });

    test('changeAppIcon for iOS', () {
      // Arrange
      final platform = ForgePlatform.iOS;
      final newIconPath = 'path/to/new/icon.png';

      // Act
      BrandForge.changeAppIcon(platform, newIconPath);

      // Assert
      // Add your assertions here to verify the app icon change
    });

    test('changeAppIcon for Android', () {
      // Arrange
      final platform = ForgePlatform.android;
      final newIconPath = 'path/to/new/icon.png';

      // Act
      BrandForge.changeAppIcon(platform, newIconPath);

      // Assert
      // Add your assertions here to verify the app icon change
    });
  });
}
