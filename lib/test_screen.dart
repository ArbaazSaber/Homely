import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;

  Future<void> _loadItems() async {
    try {
      final response = await supabase.from('categories').select('name');
      setState(() {
        _items = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading items: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Screen')),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(),)
        : ListView.builder(itemCount: _items.length, itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(title: Text(item['name'] ?? 'No Name'));
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadItems,
        child: const Icon(Icons.refresh)
    )
    );
  }
}
