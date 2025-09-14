import 'dart:io';
import 'package:path/path.dart' as p;
import '../errors/brand_forge_exception.dart';
import 'logging_service.dart';

class BackupService {
  static bool _verboseLogging = false;

  static void setVerboseLogging(bool verbose) {
    _verboseLogging = verbose;
  }

  /// Creates a timestamped backup of a file
  static String createFileBackup(File file) {
    if (!file.existsSync()) return '';

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = '${file.path}.backup.$timestamp';

    try {
      file.copySync(backupPath);
      if (_verboseLogging) {
        LoggingService.debug('Created backup: ${p.basename(backupPath)}');
      }
      return backupPath;
    } catch (e) {
      throw BrandForgeException(
        'Failed to create backup for ${file.path}',
        solution: 'Ensure you have write permissions in the directory',
        type: BrandForgeErrorType.backup,
        filePath: file.path,
        innerException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Creates a backup of an entire directory
  static String createDirectoryBackup(Directory directory) {
    if (!directory.existsSync()) return '';

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = '${directory.path}.backup.$timestamp';

    try {
      _copyDirectory(directory, Directory(backupPath));
      if (_verboseLogging) {
        LoggingService.debug('Created directory backup: ${p.basename(backupPath)}');
      }
      return backupPath;
    } catch (e) {
      throw BrandForgeException(
        'Failed to create directory backup for ${directory.path}',
        solution: 'Ensure you have write permissions in the parent directory',
        type: BrandForgeErrorType.backup,
        filePath: directory.path,
        innerException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Recursively copies a directory
  static void _copyDirectory(Directory source, Directory destination) {
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }

    for (final entity in source.listSync()) {
      final newPath = p.join(destination.path, p.basename(entity.path));
      if (entity is File) {
        entity.copySync(newPath);
      } else if (entity is Directory) {
        _copyDirectory(entity, Directory(newPath));
      }
    }
  }

  /// Cleans up old backup files (keeps only the latest 5)
  static void cleanupOldBackups(String originalPath) {
    try {
      final directory = Directory(p.dirname(originalPath));
      final baseName = p.basename(originalPath);

      final backups =
          directory
              .listSync()
              .where(
                (entity) =>
                    entity is File &&
                    entity.path.startsWith(
                      p.join(directory.path, '$baseName.backup.'),
                    ),
              )
              .cast<File>()
              .toList();

      if (backups.length > 5) {
        // Sort by modification time (newest first)
        backups.sort(
          (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
        );

        // Delete old backups (keep only 5 newest)
        for (int i = 5; i < backups.length; i++) {
          try {
            backups[i].deleteSync();
            if (_verboseLogging) {
              LoggingService.debug(
                'Cleaned up old backup: ${p.basename(backups[i].path)}',
              );
            }
          } catch (e) {
            // Non-critical error, just log if verbose
            if (_verboseLogging) {
              LoggingService.warning(
                'Could not delete old backup: ${p.basename(backups[i].path)}',
              );
            }
          }
        }
      }
    } catch (e) {
      // Non-critical error for cleanup
      if (_verboseLogging) {
        LoggingService.warning('Could not cleanup old backups for $originalPath');
      }
    }
  }

  /// Restores a file from its most recent backup
  static bool restoreFromBackup(String originalPath) {
    try {
      final directory = Directory(p.dirname(originalPath));
      final baseName = p.basename(originalPath);

      final backups =
          directory
              .listSync()
              .where(
                (entity) =>
                    entity is File &&
                    entity.path.startsWith(
                      p.join(directory.path, '$baseName.backup.'),
                    ),
              )
              .cast<File>()
              .toList();

      if (backups.isEmpty) return false;

      // Find the most recent backup
      backups.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );
      final mostRecentBackup = backups.first;

      // Restore the backup
      mostRecentBackup.copySync(originalPath);
      LoggingService.success('Restored from backup: ${p.basename(mostRecentBackup.path)}');
      return true;
    } catch (e) {
      LoggingService.error('Failed to restore from backup: $e');
      return false;
    }
  }
}
