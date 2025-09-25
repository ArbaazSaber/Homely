import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:homely/inventory_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lffugknemcxnhqdihkrb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxmZnVna25lbWN4bmhxZGloa3JiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNjQ4NTQsImV4cCI6MjA3Mjg0MDg1NH0.u_P1QkT53cOZI7dhdJK9-DIyjCUFo2tPL6uoOaCf0Ps'
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: InvetoryScreen()
    );
  }
}