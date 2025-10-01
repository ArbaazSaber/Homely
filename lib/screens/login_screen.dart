import 'package:flutter/material.dart';

import 'package:homely/screens/inventory_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _codeController.dispose();
  }

  void clearText() {
    _nameController.clear();
    _codeController.clear();
  }

  void checkLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InventoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Enter your login details'),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Code',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: clearText,
              child: const Text('Clear'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}