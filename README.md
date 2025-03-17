# BrandForge

[![pub package](https://img.shields.io/pub/v/brand_forge.svg)](https://pub.dev/packages/brand_forge)

BrandForge is a command-line tool built with Dart that helps you dynamically change your Flutter app's name and icon across multiple platforms (Android, iOS, Windows) with ease.

## Features

* **Change App Name:** Modify your app's display name for Android, iOS, and Windows platforms quickly.
* **Change App Icon:** Update your app's launcher icon for Android, iOS, and Windows with a single command.
* **Multi-Platform Support:** Designed to work seamlessly with Android, iOS, and Windows projects.
* **Easy to Use:** Simple command-line interface makes branding updates effortless.
* **Clear Logging:** Provides detailed logs with emoji indicators to show the progress and success of each operation.

## Installation

1. **Activate:**
    To install BrandForge globally, run:

    ```bash
    dart pub global activate brand_forge
    ```

    Make sure that `~/.pub-cache/bin` (or the location of your `pub` cache) is in your `PATH` environment variable.

## Usage

Navigate to the root directory of your Flutter project (where `pubspec.yaml` is located) in your terminal.

### Changing the App Name

* **Change app name for all platforms:**

    ```bash
    brand_forge --all-name "My New App Name"
    ```

* **Change the app name for iOS only:**

    ```bash
    brand_forge --ios-name "My iOS App Name"
    ```

* **Change the app name for Android only:**

    ```bash
    brand_forge --android-name "My Android App Name"
    ```

* **Change the app name for Windows only:**

    ```bash
    brand_forge --windows-name "My Windows App Name"
    ```

### Changing the App Icon

* **Change app icon for all platforms (using a file):**

    ```bash
    brand_forge --all-icon --icon-file "path/to/your/icon.png"
    ```

    or

    ```bash
    brand_forge --all-icon --icon-file "path/to/your/icon.ico"
    ```

* **Change the app icon for iOS only:**

    ```bash
    brand_forge --ios-icon --icon-file "path/to/your/icon.png"
    ```

* **Change the app icon for Android only:**

    ```bash
    brand_forge --android-icon --icon-file "path/to/your/icon.png"
    ```

* **Change the app icon for Windows only:**

    ```bash
    brand_forge --windows-icon --icon-file "path/to/your/icon.ico"
    ```

* **Change app icon from an asset**

    ```bash
    brand_forge --all-icon --icon-asset "assets/images/icon.png"
    ```

    *Currently not supported.*
* **Change app icon from an url**

    ```bash
    brand_forge --all-icon --icon-url "https://your/icon/path/icon.png"
    ```

    *Currently not supported.*

### Show Help

    ```bash
    brand_forge --help
    ```

    You will see the following.
    ```
    -h, --help                 Print this usage information.
      --all-name=<value>       Change the app name for all platforms.
      --ios-name=<value>       Change the app name for iOS.
      --android-name=<value>   Change the app name for Android.
      --windows-name=<value>   Change the app name for Windows.
      --all-icon=<value>       Change the app icon for all platforms.
      --ios-icon=<value>       Change the app icon for iOS.
      --android-icon=<value>   Change the app icon for Android.
      --windows-icon=<value>   Change the app icon for Windows.
      --icon-asset=<value>     Change the app icon from an asset.
      --icon-file=<value>      Change the app icon from a file.
      --icon-url=<value>       Change the app icon from a URL.
    ```
    
## Supported File Formats for Icons

* **Android**: `PNG`
* **iOS**: `PNG`
* **Windows**: `ICO`

## How It Works

BrandForge automatically updates the necessary files in your project:

* **Android:** `android/app/src/main/AndroidManifest.xml`
* **iOS:** `ios/Runner/Info.plist`, `ios/Runner/Assets.xcassets/AppIcon.appiconset`
* **Windows:** `windows/runner/Runner.rc`, `windows/runner/resources/app_icon.ico`

## Contributing

Contributions are welcome! If you have any suggestions or find any bugs, please open an issue or submit a pull request.

## License

[MIT License](LICENSE)
