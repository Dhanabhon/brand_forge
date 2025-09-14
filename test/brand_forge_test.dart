import 'dart:io';
import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:brand_forge/errors/brand_forge_exception.dart';
import 'package:brand_forge/services/logging_service.dart';
import 'package:test/test.dart';
import 'package:brand_forge/brand_forge.dart';

void main() {
  group('BrandForge', () {
    setUp(() {
      // Set up logging service for tests
      LoggingService.setVerboseMode(true);
      LoggingService.setSuppressEmojis(true);
    });

    test('showIntroduction should not throw', () {
      expect(() => BrandForge.showIntroduction(), returnsNormally);
    });

    test('setVerboseMode should configure services', () {
      expect(() => BrandForge.setVerboseMode(true), returnsNormally);
      expect(() => BrandForge.setVerboseMode(false), returnsNormally);
    });

    test('changeAppName should validate input', () {
      // Test with empty name
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, ''),
        throwsA(isA<BrandForgeException>()),
      );

      // Test with invalid characters
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, 'App<Name>'),
        throwsA(isA<BrandForgeException>()),
      );
    });

    test('changeAppIcon should validate input', () {
      // Test with non-existent file
      expect(
        () => BrandForge.changeAppIcon(ForgePlatform.iOS, 'non_existent.png'),
        throwsA(isA<BrandForgeException>()),
      );

      // Test with invalid file extension
      expect(
        () => BrandForge.changeAppIcon(ForgePlatform.iOS, 'invalid.txt'),
        throwsA(isA<BrandForgeException>()),
      );
    });

    test('changeAppIcon should warn for unsupported platforms', () {
      // Create a temporary valid PNG file for testing
      final tempDir = Directory.systemTemp.createTempSync();
      final validIcon = File('${tempDir.path}/test.png');
      validIcon.writeAsStringSync(
        'fake png content',
      ); // Minimal content for size validation

      try {
        // These should complete without throwing (just log warnings)
        expect(
          () => BrandForge.changeAppIcon(ForgePlatform.windows, validIcon.path),
          returnsNormally,
        );
        expect(
          () => BrandForge.changeAppIcon(ForgePlatform.macOS, validIcon.path),
          returnsNormally,
        );
        expect(
          () => BrandForge.changeAppIcon(ForgePlatform.linux, validIcon.path),
          returnsNormally,
        );
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });

  group('Platform Helper', () {
    test('should detect current platform', () {
      final currentPlatform = ForgePlatform.current;
      expect(currentPlatform, isA<ForgePlatform>());
    });
  });
}
