enum BrandForgeErrorType {
  validation,
  fileNotFound,
  filePermission,
  platformNotSupported,
  projectStructure,
  backup,
  unknown,
}

class BrandForgeException implements Exception {
  final String message;
  final String? solution;
  final BrandForgeErrorType type;
  final String? filePath;
  final Exception? innerException;

  const BrandForgeException(
    this.message, {
    this.solution,
    this.type = BrandForgeErrorType.unknown,
    this.filePath,
    this.innerException,
  });

  factory BrandForgeException.validation(String message, {String? solution}) {
    return BrandForgeException(
      message,
      solution: solution,
      type: BrandForgeErrorType.validation,
    );
  }

  factory BrandForgeException.fileNotFound(
    String filePath, {
    String? solution,
  }) {
    return BrandForgeException(
      'File not found: $filePath',
      solution: solution ?? 'Ensure the file exists and the path is correct',
      type: BrandForgeErrorType.fileNotFound,
      filePath: filePath,
    );
  }

  factory BrandForgeException.filePermission(
    String filePath, {
    String? solution,
  }) {
    return BrandForgeException(
      'Permission denied accessing file: $filePath',
      solution:
          solution ?? 'Check file permissions and ensure you have write access',
      type: BrandForgeErrorType.filePermission,
      filePath: filePath,
    );
  }

  factory BrandForgeException.platformNotSupported(
    String platform,
    String feature,
  ) {
    return BrandForgeException(
      '$feature is not yet supported on $platform',
      solution: 'This feature will be added in a future version',
      type: BrandForgeErrorType.platformNotSupported,
    );
  }

  factory BrandForgeException.projectStructure(
    String message, {
    String? solution,
  }) {
    return BrandForgeException(
      message,
      solution:
          solution ??
          'Ensure you are running this command from within a Flutter project directory',
      type: BrandForgeErrorType.projectStructure,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    // Add error type indicator
    switch (type) {
      case BrandForgeErrorType.validation:
        buffer.write('❌ Validation Error: ');
        break;
      case BrandForgeErrorType.fileNotFound:
        buffer.write('📁 File Error: ');
        break;
      case BrandForgeErrorType.filePermission:
        buffer.write('🔒 Permission Error: ');
        break;
      case BrandForgeErrorType.platformNotSupported:
        buffer.write('🚧 Platform Error: ');
        break;
      case BrandForgeErrorType.projectStructure:
        buffer.write('📂 Project Error: ');
        break;
      case BrandForgeErrorType.backup:
        buffer.write('💾 Backup Error: ');
        break;
      default:
        buffer.write('⚠️  Error: ');
    }

    buffer.write(message);

    if (filePath != null) {
      buffer.write('\nFile: $filePath');
    }

    if (solution != null) {
      buffer.write('\n💡 Solution: $solution');
    }

    if (innerException != null) {
      buffer.write('\n🔍 Details: $innerException');
    }

    return buffer.toString();
  }

  bool get isRecoverable => type != BrandForgeErrorType.projectStructure;
}
