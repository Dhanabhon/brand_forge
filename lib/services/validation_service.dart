import 'dart:io';
import 'package:path/path.dart' as p;
import '../errors/brand_forge_exception.dart';

class ValidationService {
  static const int maxAppNameLength = 100;
  static const int maxIconSizeBytes = 10 * 1024 * 1024; // 10MB
  static const List<String> validIconExtensions = [
    '.png',
    '.jpg',
    '.jpeg',
    '.ico',
  ];

  /// Validates an app name according to platform requirements
  static void validateAppName(String appName) {
    if (appName.trim().isEmpty) {
      throw BrandForgeException.validation(
        'App name cannot be empty',
        solution: 'Provide a valid app name with at least one character',
      );
    }

    if (appName.length > maxAppNameLength) {
      throw BrandForgeException.validation(
        'App name is too long (maximum $maxAppNameLength characters)',
        solution: 'Use a shorter app name',
      );
    }

    // Check for invalid characters in app names
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    if (invalidChars.hasMatch(appName)) {
      final foundChars = invalidChars
          .allMatches(appName)
          .map((e) => e.group(0))
          .toSet()
          .join(', ');
      throw BrandForgeException.validation(
        'App name contains invalid characters: $foundChars',
        solution: 'Remove special characters like < > : " / \\ | ? *',
      );
    }

    // Check for leading/trailing spaces
    if (appName != appName.trim()) {
      throw BrandForgeException.validation(
        'App name cannot have leading or trailing spaces',
        solution: 'Remove extra spaces from the beginning or end',
      );
    }
  }

  /// Validates an icon file path and properties
  static void validateIconFile(String iconPath) {
    final File iconFile = File(iconPath);

    if (!iconFile.existsSync()) {
      throw BrandForgeException.fileNotFound(
        iconPath,
        solution: 'Check the file path and ensure the file exists',
      );
    }

    // Check file size
    try {
      final fileSizeBytes = iconFile.lengthSync();
      if (fileSizeBytes > maxIconSizeBytes) {
        final sizeMB = (fileSizeBytes / 1024 / 1024).toStringAsFixed(1);
        throw BrandForgeException.validation(
          'Icon file is too large: ${sizeMB}MB',
          solution:
              'Use an icon file smaller than ${maxIconSizeBytes ~/ 1024 ~/ 1024}MB',
        );
      }

      if (fileSizeBytes == 0) {
        throw BrandForgeException.validation(
          'Icon file is empty',
          solution: 'Use a valid icon file with content',
        );
      }
    } catch (e) {
      if (e is BrandForgeException) rethrow;
      throw BrandForgeException.filePermission(
        iconPath,
        solution: 'Ensure you have read permissions for the file',
      );
    }

    // Check file extension
    final extension = p.extension(iconPath).toLowerCase();
    if (!validIconExtensions.contains(extension)) {
      throw BrandForgeException.validation(
        'Unsupported icon format: $extension',
        solution: 'Use one of these formats: ${validIconExtensions.join(", ")}',
      );
    }
  }

  /// Validates that the current directory is within a Flutter project
  static String validateAndFindProjectRoot() {
    Directory current = Directory.current;
    while (current.path != current.parent.path) {
      final pubspecPath = p.join(current.path, 'pubspec.yaml');
      if (File(pubspecPath).existsSync()) {
        return current.path;
      }
      current = current.parent;
    }

    throw BrandForgeException.projectStructure(
      'Could not find Flutter project root directory',
      solution:
          'Ensure you are running this command from within a Flutter project directory',
    );
  }

  /// Validates that a platform directory exists
  static void validatePlatformDirectory(
    String platformPath,
    String platformName,
  ) {
    if (!Directory(platformPath).existsSync()) {
      throw BrandForgeException.fileNotFound(
        platformPath,
        solution:
            'Add $platformName platform support by running: flutter create --platforms=$platformName .',
      );
    }
  }

  /// Validates that a required file exists
  static void validateRequiredFile(String filePath, String platformName) {
    if (!File(filePath).existsSync()) {
      throw BrandForgeException.fileNotFound(
        filePath,
        solution:
            'Ensure you are running this from a Flutter project with $platformName support',
      );
    }
  }
}
