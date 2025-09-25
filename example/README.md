# BrandForge Example App

A comprehensive demonstration of BrandForge's enhanced service-oriented architecture and error handling capabilities.

## 🎯 What This Example Demonstrates

This Flutter application showcases all the key features of BrandForge:

### 🏗️ **Service Architecture**
- **ValidationService**: Input validation and project structure validation
- **LoggingService**: Multi-level logging with real-time display
- **BackupService**: Intelligent backup management with restoration capabilities
- **Enhanced Error Handling**: Typed exceptions with detailed error information

### 🔧 **Core Features**
- **Dynamic App Name Changes**: Change app names for any supported platform
- **App Icon Changes**: Update app icons for iOS and Android (with platform warnings)
- **Platform Selection**: Choose target platform from dropdown
- **Real-time Validation**: Live validation demonstrations
- **Comprehensive Logging**: View all operations in real-time log display
- **Verbose Mode**: Toggle detailed logging output
- **Error Recovery**: Proper error handling with user-friendly messages

### 🛡️ **Safety Features**
- **Input Validation**: Real-time validation with helpful error messages
- **Backup System**: Automatic file backups with restoration capabilities
- **Error Handling**: Comprehensive error catching with solutions
- **Platform Support Warnings**: Clear indicators for unsupported features

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.0 or higher
- Dart SDK 3.7.0 or higher
- A Flutter project with platform support (iOS, Android, Windows, macOS, Linux)

### Running the Example

1. **Navigate to the example directory:**
   ```bash
   cd example/
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🎮 Using the Example App

### 1. **Platform Selection**
- Use the dropdown to select your target platform
- The app will show warnings for unsupported features

### 2. **Changing App Names**
- Enter a new app name in the text field
- Click "Change App Name" to apply the change
- Use "Test Validation" to see validation examples

### 3. **Changing App Icons**
- Enter the path to an icon file
- Click "Change App Icon" to apply the change
- Note: Only supported on iOS and Android

### 4. **Monitoring Operations**
- Toggle "Verbose Logging" for detailed output
- Watch the logs section for real-time feedback
- Copy logs to clipboard for debugging
- Clear logs when needed

### 5. **Error Handling**
- Try invalid inputs to see error handling
- Observe detailed error messages with solutions
- Notice automatic recovery and user guidance

## 🔬 Testing Scenarios

The example app includes several testing scenarios:

### **Validation Tests**
- Empty app names
- Names that are too long (>100 characters)
- Names with invalid characters (`< > : " / \ | ? *`)
- Names with leading/trailing spaces
- Valid app names

### **Error Scenarios**
- Non-existent icon files
- Invalid file extensions
- Files that are too large (>10MB)
- Platform-specific unsupported operations

### **Platform Support**
- Test app name changes on all platforms
- Test icon changes on supported platforms (iOS, Android)
- See warnings for unsupported platform features

## 📁 Project Structure

```
example/
├── lib/
│   └── main.dart              # Main example application
├── pubspec.yaml               # Dependencies and configuration
├── README.md                  # This documentation
└── test/
    └── widget_test.dart       # Basic widget tests
```

## 🧪 Advanced Usage

### **Custom Validation**
```dart
try {
  ValidationService.validateAppName(appName);
  // Proceed with app name change
} on BrandForgeException catch (e) {
  // Handle validation errors with solutions
  print('Error: ${e.message}');
  if (e.solution != null) {
    print('Solution: ${e.solution}');
  }
}
```

### **Verbose Logging**
```dart
// Enable verbose mode for detailed operations
BrandForge.setVerboseMode(true);

// Perform operations with detailed logging
BrandForge.changeAppName(ForgePlatform.iOS, 'New App Name');
```

### **Error Recovery**
```dart
try {
  BrandForge.changeAppIcon(platform, iconPath);
} on BrandForgeException catch (e) {
  if (e.type == BrandForgeErrorType.fileNotFound) {
    // Handle file not found specifically
  } else if (e.type == BrandForgeErrorType.platformNotSupported) {
    // Handle unsupported platform operations
  }
}
```

## 🛠️ Development Notes

- The example uses the latest BrandForge service architecture
- All print statements have been replaced with LoggingService calls
- Comprehensive error handling demonstrates best practices
- Real-time logging shows internal BrandForge operations
- Platform detection automatically selects the current platform

## 📞 Support

For issues with this example or BrandForge itself:
- 📖 Check the main [BrandForge documentation](../README.md)
- 🐛 Report bugs on [GitHub Issues](https://github.com/Dhanabhon/brand_forge/issues)
- 💬 Ask questions in [GitHub Discussions](https://github.com/Dhanabhon/brand_forge/discussions)
