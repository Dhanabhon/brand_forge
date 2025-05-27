import 'package:flutter/material.dart';

import 'package:brand_forge/brand_forge.dart';
import 'package:brand_forge/helpers/platform_helper.dart';

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
      ),
      home: const HomePage(title: 'Brand Forge'),
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

  @override
  void initState() {
    super.initState();
    // Initialize the text field with the current app name
    _nameController.text = "BrandForge";
  }

  // Method to change the app name
  void _changeAppName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    try {
      BrandForge.changeAppName(ForgePlatform.current, newName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App name changed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to change app name: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'New App Name',
                hintText: 'Enter new app name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _changeAppName,
              child: Text('Change App Name'),
            ),
            // const SizedBox(height: 24),
            // const Text('Choose Icon App'),
            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
