# BrandForge: Dynamically Brand Your Flutter App

[![pub package](https://img.shields.io/pub/v/brand_forge.svg)](https://pub.dev/packages/brand_forge)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

BrandForge is a powerful Flutter package that empowers you to dynamically change your Flutter application's name and icon directly from the command line or within your Dart code. This is incredibly useful for white-labeling, creating multiple app variants, or managing different branding strategies.

## ✨ Key Features

* **Dynamic App Name Changes:** Effortlessly modify the display name of your app for both iOS and Android platforms.
* **Custom App Icons:** Swap out your app's icon with ease, allowing for complete visual rebranding on both platforms.
* **Comprehensive Logging:** Track the changes made by BrandForge with detailed logging, including informative messages, progress indicators, success confirmations, and error reports.
* **Command-Line Interface (CLI):**  Operate BrandForge via the command line for efficient automation.
* **Programmatic API:** Integrate BrandForge directly within your Dart code for complete flexibility.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following:

* **Flutter SDK:** Version 3.29.1 or higher.
* **Dart SDK:** Version 3.7.0 or higher.
* **Development Environment:** A working development environment configured for Flutter (e.g., Android Studio, VS Code).
* **Command-Line Access:** You are comfortable using the command line or terminal.
* **Image Converter:** To change the app icons, you need an image conversion tool.

### Installation

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

3. **(Optional) Activate Globally:**
    If you want to use the `brand_forge` command globally, run:

    ```sh
    flutter pub global activate --source git https://github.com/Dhanabhon/brand_forge.git
    ```

    Ensure that you have added the Pub cache bin directory to your PATH environment variable. You can follow [this](https://dart.dev/tools/pub/cmd/pub-global) instruction.

## 🛠️ Usage

### Command-Line Interface (CLI)

Here are examples of how to use BrandForge via the command line:

**Change the iOS App Name:**

```bash
   dart run brand_forge:main --ios-name "My New App Name"
```

**Change the Android App Name:**

```bash
   dart run brand_forge:main --android-name "My New App Name"
```

**Change the Windows App Name:**

```bash
   dart run brand_forge:main --windows-name "My New App Name"
```

**Change All App Names:**

```bash
   dart run brand_forge:main --all-name "My New App Name"
```

**Testing:** The app name change functionality has been extensively tested on both iOS and Android devices and emulators. Successful changes were verified by rebuilding and running the application after using the CLI commands.

## Note

Currently, BrandForge **supports renaming apps on iOS, Android, and Windows platforms**. Future updates will include support for macOS, Linux, and Web platforms.
