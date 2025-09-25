import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:brand_forge/brand_forge.dart';
import 'package:brand_forge/helpers/platform_helper.dart';
import 'package:brand_forge/errors/brand_forge_exception.dart';
import 'package:brand_forge/services/logging_service.dart';
import 'package:brand_forge/services/validation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrandForge Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'BrandForge Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconPathController = TextEditingController();
  final List<String> _logMessages = [];
  bool _verboseMode = false;
  bool _isProcessing = false;
  ForgePlatform _selectedPlatform = ForgePlatform.current;

  @override
  void initState() {
    super.initState();
    _nameController.text = "BrandForge Demo";
    _iconPathController.text = "assets/icon.png";

    // Initialize logging service
    LoggingService.setVerboseMode(_verboseMode);
  }

  void _addLogMessage(String message, {bool isError = false}) {
    setState(() {
      _logMessages.add(
        '${DateTime.now().toString().substring(11, 19)}: $message',
      );
    });
    if (_logMessages.length > 50) {
      _logMessages.removeAt(0);
    }
  }

  void _clearLogs() {
    setState(() {
      _logMessages.clear();
    });
  }

  void _toggleVerboseMode(bool value) {
    setState(() {
      _verboseMode = value;
    });
    BrandForge.setVerboseMode(_verboseMode);
    LoggingService.setVerboseMode(_verboseMode);
    _addLogMessage('Verbose mode ${_verboseMode ? "enabled" : "disabled"}');
  }

  Future<void> _changeAppName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      _showSnackBar('Please enter an app name', isError: true);
      return;
    }

    setState(() => _isProcessing = true);
    _addLogMessage('Starting app name change for ${_selectedPlatform.name}...');

    try {
      // Demonstrate validation
      ValidationService.validateAppName(newName);
      _addLogMessage('✓ App name validation passed');

      // Change the app name
      BrandForge.changeAppName(_selectedPlatform, newName);
      _addLogMessage('✅ App name changed successfully to "$newName"');
      _showSnackBar('App name changed successfully!');
    } on BrandForgeException catch (e) {
      _addLogMessage('❌ BrandForge Error: ${e.message}', isError: true);
      if (e.solution != null) {
        _addLogMessage('💡 Solution: ${e.solution}');
      }
      _showSnackBar('Error: ${e.message}', isError: true);
    } catch (e) {
      _addLogMessage('❌ Unexpected error: $e', isError: true);
      _showSnackBar('Unexpected error: $e', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _changeAppIcon() async {
    final iconPath = _iconPathController.text.trim();
    if (iconPath.isEmpty) {
      _showSnackBar('Please enter an icon path', isError: true);
      return;
    }

    setState(() => _isProcessing = true);
    _addLogMessage('Starting app icon change for ${_selectedPlatform.name}...');

    try {
      // Check if file exists first
      if (!File(iconPath).existsSync()) {
        throw BrandForgeException.fileNotFound(iconPath);
      }

      // Validate the icon file
      ValidationService.validateIconFile(iconPath);
      _addLogMessage('✓ Icon file validation passed');

      // Change the app icon
      BrandForge.changeAppIcon(_selectedPlatform, iconPath);
      _addLogMessage('✅ App icon changed successfully');
      _showSnackBar('App icon changed successfully!');
    } on BrandForgeException catch (e) {
      _addLogMessage('❌ BrandForge Error: ${e.message}', isError: true);
      if (e.solution != null) {
        _addLogMessage('💡 Solution: ${e.solution}');
      }
      _showSnackBar('Error: ${e.message}', isError: true);
    } catch (e) {
      _addLogMessage('❌ Unexpected error: $e', isError: true);
      _showSnackBar('Unexpected error: $e', isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _demonstrateValidation() {
    _addLogMessage('🧪 Running validation demonstrations...');

    // Test various validation scenarios
    final testCases = [
      ('', 'Empty name'),
      ('A' * 101, 'Name too long'),
      ('App<Name>', 'Invalid characters'),
      (' App Name ', 'Leading/trailing spaces'),
      ('Valid App Name', 'Valid name'),
    ];

    for (final (name, description) in testCases) {
      try {
        ValidationService.validateAppName(name);
        _addLogMessage('✓ $description: PASSED');
      } on BrandForgeException catch (e) {
        _addLogMessage('❌ $description: ${e.message}');
      }
    }

    _addLogMessage('🧪 Validation demonstration complete');
  }

  void _showBackupInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Backup System'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BrandForge automatically creates backups:'),
                SizedBox(height: 8),
                Text('• Timestamped backups before changes'),
                Text('• Automatic cleanup (keeps 5 most recent)'),
                Text('• Restoration capability'),
                Text('• Directory and file backup support'),
                SizedBox(height: 12),
                Text('Backup files are named with timestamps:'),
                Text(
                  'filename.ext.backup.1640995200000',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyLogsToClipboard() {
    final allLogs = _logMessages.join('\n');
    Clipboard.setData(ClipboardData(text: allLogs));
    _showSnackBar('Logs copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showBackupInfo,
            tooltip: 'Backup System Info',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Platform Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Target Platform:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ForgePlatform>(
                        initialValue: _selectedPlatform,
                        items:
                            ForgePlatform.values.map((platform) {
                              return DropdownMenuItem(
                                value: platform,
                                child: Text(platform.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedPlatform = value!);
                          _addLogMessage('Selected platform: ${value!.name}');
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // App Name Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'App Name Change:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'New App Name',
                          hintText: 'Enter new app name',
                          border: OutlineInputBorder(),
                          helperText:
                              'Max 100 characters, no special characters',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _isProcessing ? null : _changeAppName,
                            child:
                                _isProcessing
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Change App Name'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: _demonstrateValidation,
                            child: const Text('Test Validation'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // App Icon Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'App Icon Change:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _iconPathController,
                        decoration: const InputDecoration(
                          labelText: 'Icon File Path',
                          hintText: 'Enter path to icon file',
                          border: OutlineInputBorder(),
                          helperText:
                              'Supports .png, .jpg, .jpeg, .ico (max 10MB)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isProcessing ? null : _changeAppIcon,
                        child:
                            _isProcessing
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Change App Icon'),
                      ),
                      if (_selectedPlatform == ForgePlatform.windows ||
                          _selectedPlatform == ForgePlatform.macOS ||
                          _selectedPlatform == ForgePlatform.linux)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            '⚠️ Icon changes not yet supported for this platform',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Settings Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SwitchListTile(
                        title: const Text('Verbose Logging'),
                        subtitle: const Text('Enable detailed logging output'),
                        value: _verboseMode,
                        onChanged: _toggleVerboseMode,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Logs Section
              SizedBox(
                height: 300,
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Text(
                              'Logs:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: _copyLogsToClipboard,
                              tooltip: 'Copy logs',
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearLogs,
                              tooltip: 'Clear logs',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child:
                              _logMessages.isEmpty
                                  ? const Center(
                                    child: Text(
                                      'No logs yet. Try changing the app name or icon!',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: _logMessages.length,
                                    itemBuilder: (context, index) {
                                      final message = _logMessages[index];
                                      final isError = message.contains('❌');
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          message,
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 12,
                                            color:
                                                isError
                                                    ? Colors.red
                                                    : Colors.black87,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
