import 'dart:io';
import 'package:brand_forge/errors/brand_forge_exception.dart';
import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:brand_forge/services/validation_service.dart';
import 'package:test/test.dart';

void main() {
  group('BrandForge CLI Tests', () {
    test('should validate app name correctly', () {
      // Test valid app names (will throw because files don't exist, but validation passes)
      expect(
        () => ValidationService.validateAppName('Valid App Name'),
        returnsNormally,
      );

      // Test empty app name
      expect(
        () => ValidationService.validateAppName(''),
        throwsA(isA<BrandForgeException>()),
      );

      // Test app name that's too long
      final longName = 'A' * 101;
      expect(
        () => ValidationService.validateAppName(longName),
        throwsA(isA<BrandForgeException>()),
      );

      // Test app name with invalid characters
      expect(
        () => ValidationService.validateAppName('App<Name>'),
        throwsA(isA<BrandForgeException>()),
      );

      // Test app name with leading/trailing spaces
      expect(
        () => ValidationService.validateAppName(' App Name '),
        throwsA(isA<BrandForgeException>()),
      );
    });

    test('should validate icon file correctly', () {
      // Test non-existent file
      expect(
        () => ValidationService.validateIconFile('non_existent.png'),
        throwsA(isA<BrandForgeException>()),
      );

      // Test invalid file extension
      final tempDir = Directory.systemTemp.createTempSync();
      final invalidFile = File('${tempDir.path}/test.txt');
      invalidFile.writeAsStringSync('test content');

      expect(
        () => ValidationService.validateIconFile(invalidFile.path),
        throwsA(isA<BrandForgeException>()),
      );

      // Test empty file
      final emptyFile = File('${tempDir.path}/empty.png');
      emptyFile.writeAsStringSync('');

      expect(
        () => ValidationService.validateIconFile(emptyFile.path),
        throwsA(isA<BrandForgeException>()),
      );

      // Cleanup
      tempDir.deleteSync(recursive: true);
    });

    test('should find project root correctly', () {
      // This test runs in project directory, should find pubspec.yaml
      expect(
        () => ValidationService.validateAndFindProjectRoot(),
        returnsNormally,
      );

      final projectRoot = ValidationService.validateAndFindProjectRoot();
      expect(projectRoot, isNotEmpty);
      expect(File('$projectRoot/pubspec.yaml').existsSync(), isTrue);
    });

    test('BrandForgeException should format message correctly', () {
      final exception = BrandForgeException(
        'Test error',
        solution: 'Test solution',
        type: BrandForgeErrorType.validation,
      );
      expect(exception.toString(), contains('Test error'));
      expect(exception.toString(), contains('💡 Solution: Test solution'));
      expect(exception.toString(), contains('❌ Validation Error:'));

      final exceptionNoSolution = BrandForgeException('Test error');
      expect(exceptionNoSolution.toString(), contains('Test error'));

      // Test factory constructors
      final fileNotFound = BrandForgeException.fileNotFound('/test/path');
      expect(fileNotFound.toString(), contains('📁 File Error:'));
      expect(fileNotFound.filePath, equals('/test/path'));

      final platformNotSupported = BrandForgeException.platformNotSupported(
        'macOS',
        'icon change',
      );
      expect(platformNotSupported.toString(), contains('🚧 Platform Error:'));
    });
  });

  group('Platform Helper Tests', () {
    test('should detect current platform', () {
      final currentPlatform = ForgePlatform.current;
      expect(currentPlatform, isA<ForgePlatform>());
    });
  });
}
