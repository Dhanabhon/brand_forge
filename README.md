# BrandForge: Dynamically Brand Your Flutter App

[![pub package](https://img.shields.io/pub/v/brand_forge.svg)](https://pub.dev/packages/brand_forge)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

BrandForge is a powerful Flutter package that empowers you to dynamically change your Flutter application's name and icon directly from the command line or within your Dart code. This is incredibly useful for white-labeling, creating multiple app variants, or managing different branding strategies.

## ✨ Key Features

* **Dynamic App Name Changes:** Effortlessly modify the display name of your app for all supported platforms (iOS, Android, Windows, macOS, Linux).
* **Custom App Icons:** Swap out your app's icon with ease for iOS and Android platforms, with additional platform support coming soon.
* **Enhanced Logging System:** Multi-level logging (debug, info, progress, success, warning, error) with optional verbose mode and emoji support.
* **Intelligent Backup System:** Automatic timestamped backups of all modified files with cleanup of old backups to save space.
* **Robust Error Handling:** Typed exceptions with detailed error messages, solutions, and recovery guidance.
* **Comprehensive Validation:** Input validation for app names, icon files, and project structure with helpful error messages.
* **Command-Line Interface (CLI):** Operate BrandForge via the command line for efficient automation with verbose logging support.
* **Programmatic API:** Integrate BrandForge directly within your Dart code for complete flexibility.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following:

* **Flutter SDK:** Version 3.29.1 or higher.
* **Dart SDK:** Version 3.7.0 or higher.
* **Development Environment:** A working development environment configured for Flutter (e.g., Android Studio, VS Code).
* **Command-Line Access:** You are comfortable using the command line or terminal.

### Installation

### Option 1: Add as Dev Dependency (Recommended)

1. **Add Dependency:**
    Open your project's `pubspec.yaml` file and add BrandForge as a dependency:

    ```yaml
    dev_dependencies:
      brand_forge:
        git:
          url: https://github.com/Dhanabhon/brand_forge.git
          ref: main
    ```

2. **Get Package:**
    Run the following command in your project's root directory:

    ```sh
    flutter pub get
    ```

## **Option 2: Global Installation**

If you want to use the `brand_forge` command globally, run:

```sh
   flutter pub global activate --source git https://github.com/Dhanabhon/brand_forge.git
```

**Important:** Ensure that you have added the Pub cache bin directory to your PATH environment variable. You can follow [this](https://dart.dev/tools/pub/cmd/pub-global) instruction.

## 🛠️ Usage

### Command-Line Interface (CLI)

Navigate to your Flutter project root directory and use the following commands:

### Basic Usage

```bash
   # Show help
   dart run brand_forge --help

   # Show version
   dart run brand_forge --version

   # Show introduction
   dart run brand_forge
```

### Change App Names

```bash
   # Change iOS app name
   dart run brand_forge --ios-name "My Awesome App"

   # Change Android app name
   dart run brand_forge --android-name "My Awesome App"

   # Change Windows app name
   dart run brand_forge --windows-name "My Awesome App"

   # Change macOS app name
   dart run brand_forge --macos-name "My Awesome App"

   # Change Linux app name
   dart run brand_forge --linux-name "My Awesome App"

   # Change app name for all platforms at once
   dart run brand_forge --all-name "My Awesome App"
```

### Change App Icons

```bash
   # Change iOS app icon
   dart run brand_forge --ios-icon "path/to/icon.png"

   # Change Android app icon
   dart run brand_forge --android-icon "path/to/icon.png"

   # Change app icon for all supported platforms
   dart run brand_forge --all-icon "path/to/icon.png"

   # Note: Windows, macOS, and Linux icon changes are not yet implemented
```

### Combine Commands

```bash
   # Change both name and icon
   dart run brand_forge --ios-name "My App" --ios-icon "icon.png"

   # Multiple platforms
   dart run brand_forge --ios-name "My App" --android-name "My App" --ios-icon "icon.png"

   # Enable verbose logging
   dart run brand_forge --all-name "My App" --verbose
```

### Global Usage (if installed globally)

If you've installed BrandForge globally, you can use it from any Flutter project:

```bash
   brand_forge --all-name "My Awesome App"
   brand_forge --ios-icon "path/to/icon.png"
```

## Programmatic API

You can also use BrandForge directly in your Dart code:

```dart
   import 'package:brand_forge/brand_forge.dart';
   import 'package:brand_forge/helpers/platform_helper.dart';
   import 'package:brand_forge/errors/brand_forge_exception.dart';

   void main() {
      try {
         // Enable verbose logging for detailed output
         BrandForge.setVerboseMode(true);

         // Change app name
         BrandForge.changeAppName(ForgePlatform.iOS, 'My New App');
         BrandForge.changeAppName(ForgePlatform.android, 'My New App');

         // Change app icon (iOS and Android supported)
         BrandForge.changeAppIcon(ForgePlatform.iOS, 'assets/icon.png');
         BrandForge.changeAppIcon(ForgePlatform.android, 'assets/icon.png');

         print('✅ Branding updated successfully!');
      } catch (e) {
         if (e is BrandForgeException) {
           print(e.toString()); // Includes detailed error info and solutions
         } else {
           print('❌ Unexpected error: $e');
         }
      }
   }
```

## 📋 Supported Platforms

| Platform | App Name | App Icon | Status |
| --- | --- | --- | --- |
| iOS | ✅ | ✅ | Fully Supported |
| Android | ✅ | ✅ | Fully Supported |
| Windows | ✅ | ⏳ | Name Only |
| macOS | ✅ | ⏳ | Name Only |
| Linux | ✅ | ⏳ | Name Only |

## 🔧 File Locations Modified

### iOS

- **App Name:** `ios/Runner/Info.plist` (CFBundleDisplayName, CFBundleName)

- **App Icon:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Android

- **App Name:** `android/app/src/main/AndroidManifest.xml` (android:label)

- **App Icon:** `android/app/src/main/res/mipmap-*/ic_launcher.png`

### Windows

- **App Name:** `windows/runner/main.cpp` (window title)

- **App Icon:** Not yet implemented

### macOS

- **App Name:** `macos/Runner/Info.plist` (CFBundleName)

- **App Icon:** Not yet implemented

### Linux

- **App Name:** `linux/runner/my_application.cc` (GTK window title)

- **App Icon:** Not yet implemented

## 🛡️ Safety & Reliability Features

### Intelligent Backup System

BrandForge automatically creates backups of all modified files with timestamps:

- **Single files:** `filename.ext.backup.1640995200000`
- **Directories:** `dirname.backup.1640995200000`
- **Automatic cleanup:** Keeps only the 5 most recent backups to save disk space
- **Backup restoration:** Built-in capability to restore from the most recent backup

### Comprehensive Input Validation

- **App Names:**
  - Must not be empty or contain only whitespace
  - Maximum length of 100 characters
  - No invalid characters: `< > : " / \ | ? *`
  - No leading or trailing spaces

- **Icon Files:**
  - Must exist and be accessible
  - Maximum size of 10MB
  - Valid extensions: `.png`, `.jpg`, `.jpeg`, `.ico`
  - Cannot be empty files

- **Project Structure:** Validates Flutter project structure and platform support before making changes

### Enhanced Error Handling

Typed error system with detailed, actionable error messages:

```sh
❌ Validation Error: App name contains invalid characters: <, >
💡 Solution: Remove special characters like < > : " / \ | ? *

📁 File Error: File not found: /path/to/icon.png
File: /path/to/icon.png
💡 Solution: Ensure the file exists and the path is correct

🚧 Platform Error: App icon change is not yet supported on macOS
💡 Solution: This feature will be added in a future version
```

### Service-Oriented Architecture

- **ValidationService:** Centralized input and project validation
- **LoggingService:** Multi-level logging with formatting options
- **BackupService:** Intelligent file backup and restoration
- **Separation of Concerns:** Each service handles specific functionality

## 🧪 Testing

Run the comprehensive test suite:

```bash
   dart test
```

The enhanced test suite covers:

- **Input validation:** App name and icon file validation
- **Error handling:** All exception types and error scenarios
- **Platform detection:** Cross-platform compatibility
- **CLI argument parsing:** Command-line interface functionality
- **Service functionality:** Validation, logging, and backup services
- **Integration tests:** End-to-end functionality testing
- **Edge cases:** Boundary conditions and error recovery

### Test Architecture

- **Unit tests:** Individual service and utility testing
- **Integration tests:** Cross-service functionality
- **Mocking:** Isolated testing of file operations
- **Error simulation:** Testing error conditions and recovery

## 🚧 Upcoming Features

- **Complete Icon Support:** Windows, macOS, and Linux icon changes
- **Web Platform Support:** Progressive Web App configuration
- **Advanced Configuration:** YAML configuration files and templates
- **Batch Operations:** Process multiple projects at once
- **Icon Processing:** Automatic resizing and format conversion
- **Backup Management:** Advanced backup policies and retention settings
- **Template System:** Pre-configured branding templates
- **CI/CD Integration:** GitHub Actions and other CI/CD pipeline support
- **Configuration Profiles:** Save and reuse branding configurations
- **Rollback System:** Easy rollback to previous branding states

## 🤝 Contributing

We welcome contributions! Please see our [Code of Conduct](https://github.com/Dhanabhon/brand_forge/blob/main/CODE_OF_CONDUCT.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/Dhanabhon/brand_forge/blob/main/LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

"Could not find Flutter project root directory"

- Ensure you're running the command from within a Flutter project directory

- Check that `pubspec.yaml` exists in your current directory or parent directories

### "Permission denied" errors

- On Unix systems, ensure you have write permissions to the project files
- Try running with appropriate permissions
- Check that backup directories are writable

### "File not found" errors for platform-specific files

- Ensure the target platform is added to your Flutter project
- Run `flutter create --platforms=ios,android,windows,macos,linux .` to add missing platforms
- Verify platform directories exist in your project structure

### Verbose Mode for Troubleshooting

Enable detailed logging to diagnose issues:

```bash
   dart run brand_forge --all-name "My App" --verbose
```

Verbose mode provides:
- Detailed operation progress
- File backup notifications
- Validation step-by-step information
- Enhanced error context

### Service-Specific Issues

**ValidationService Issues:**
- Project root detection problems
- Platform directory validation failures
- Input format validation errors

**BackupService Issues:**
- Insufficient disk space for backups
- Permission issues creating backup directories
- Backup cleanup problems

**LoggingService Issues:**
- Output formatting problems
- Verbose mode not working
- Emoji display issues in certain terminals

## Getting Help

- 📖 Check the documentation above

- 🐛 Report bugs on [GitHub Issues](https://github.com/Dhanabhon/brand_forge/issues)

- 💬 Ask questions in [GitHub Discussions](https://github.com/Dhanabhon/brand_forge/discussions)

---

Made with ❤️ by the BrandForge