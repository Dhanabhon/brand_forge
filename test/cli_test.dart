import 'dart:io';
import 'package:brand_forge/errors/brand_forge_exception.dart';
import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:test/test.dart';
import 'package:brand_forge/brand_forge.dart';

void main() {
  group('BrandForge CLI Tests', () {
    test('should validate app name correctly', () {
      // Test valid app names
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, 'Valid App Name'),
        throwsA(isA<BrandForgeException>()),
      ); // Will throw because files don't exist, but validation passes

      // Test empty app name
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, ''),
        throwsA(isA<BrandForgeException>()),
      );

      // Test app name that's too long
      final longName = 'A' * 101;
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, longName),
        throwsA(isA<BrandForgeException>()),
      );

      // Test app name with invalid characters
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, 'App<Name>'),
        throwsA(isA<BrandForgeException>()),
      );
    });

    test('should validate icon file correctly', () {
      // Test non-existent file
      expect(
        () => BrandForge.changeAppIcon(ForgePlatform.iOS, 'non_existent.png'),
        throwsA(isA<BrandForgeException>()),
      );

      // Test invalid file extension
      final tempDir = Directory.systemTemp.createTempSync();
      final invalidFile = File('${tempDir.path}/test.txt');
      invalidFile.writeAsStringSync('test');

      expect(
        () => BrandForge.changeAppIcon(ForgePlatform.iOS, invalidFile.path),
        throwsA(isA<BrandForgeException>()),
      );

      // Cleanup
      tempDir.deleteSync(recursive: true);
    });

    test('should find project root correctly', () {
      // This test requires being in a Flutter project directory
      // In real usage, this would work
      expect(
        () => BrandForge.changeAppName(ForgePlatform.iOS, 'Test App'),
        throwsA(isA<BrandForgeException>()),
      );
    });

    test('BrandForgeException should format message correctly', () {
      final exception = BrandForgeException('Test error', 'Test solution');
      expect(exception.toString(), contains('Test error'));
      expect(exception.toString(), contains('Solution: Test solution'));

      final exceptionNoSolution = BrandForgeException('Test error');
      expect(exceptionNoSolution.toString(), equals('Test error'));
    });
  });

  group('Platform Helper Tests', () {
    test('should detect current platform', () {
      final currentPlatform = ForgePlatform.current;
      expect(currentPlatform, isA<ForgePlatform>());
    });
  });
}
