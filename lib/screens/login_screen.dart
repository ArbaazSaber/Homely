import 'package:flutter/material.dart';

import 'package:homely/screens/inventory_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:homely/model/user.dart' as userModel;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  bool _isLoading = false;
  String? _errorMessage;

  final supabase = Supabase.instance.client;

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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final code = _codeController.text.trim();

    try {
      final response = await supabase
          .from('users')
          .select('''
            *, family:families(*)
          ''')
          .eq('name', name)
          .eq('code', code)
          .maybeSingle();

      if (response == null) {
        setState(() {
          _errorMessage = "Invalid Name or Code!";
        });
      } else {
        final user = userModel.User.fromJson(response);

        // Store User somewhere

        if (mounted) _confirmLogin(user);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _confirmLogin(userModel.User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InventoryScreen(user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Center(
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
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
                  const SizedBox(height: 50),
                  Text(_errorMessage ?? ""),
                ],
              ),
            ),
    );
  }
}
