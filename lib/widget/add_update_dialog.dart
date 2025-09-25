import 'package:flutter/material.dart';
import 'package:homely/model/category.dart';
import 'package:homely/model/inventory_item.dart';
import 'package:homely/model/location.dart';
import 'package:homely/model/user.dart';

class AddUpdateDialog extends StatefulWidget {
  final InventoryItem item;
  final String function; // 'Add' or 'Update'
  final List<Category> categories; // from DB
  final List<Location> locations; // from DB
  final User currentUser; // from DB

  const AddUpdateDialog({
    super.key,
    required this.function,
    required this.item,
    required this.categories,
    required this.locations,
    required this.currentUser,
  });

  @override
  State<AddUpdateDialog> createState() => _AddUpdateDialogState();
}

class _AddUpdateDialogState extends State<AddUpdateDialog> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController unitController;
  bool replenishable = true;
  Category? selectedCategory;
  Location? selectedLocation;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    unitController = TextEditingController(text: widget.item.unit);

    selectedCategory = widget.item.category;
    selectedLocation = widget.item.location;
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    unitController.dispose();
    super.dispose();
  }

  void _submitUpdate() {
    if (nameController.text.isEmpty ||
        quantityController.text.isEmpty ||
        unitController.text.isEmpty ||
        selectedCategory == null ||
        selectedLocation == null) {
      // Show error
      return;
    }

    final updatedItem = InventoryItem(
      id: widget.item.id,
      name: nameController.text,
      quantity: double.tryParse(quantityController.text) ?? 0,
      unit: unitController.text,
      category: selectedCategory!,
      location: selectedLocation!,
      updatedBy: widget.currentUser,
      family: widget.currentUser.family,
      lastUpdated: DateTime.now(),
      isReplenishable: replenishable, // Replace with actual user
    );

    // SUPABASE UPDATE LOGIC HERE

    Navigator.of(context).pop(updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.function} Inventory Item"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: unitController,
              decoration: InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownMenu<String>(
              enableSearch: true,
              enableFilter: true,
              menuHeight: 300,
              width: double.infinity,
              initialSelection: selectedCategory,
              dropdownMenuEntries: widget.categories
                  .map((c) => DropdownMenuEntry(label: c, value: c))
                  .toList(),
              onSelected: (val) => setState(() => selectedCategory = val),
              label: const Text('Category'),
            ),
            SizedBox(height: 16),
            DropdownMenu<String>(
              enableSearch: true,
              enableFilter: true,
              menuHeight: 300,
              width: double.infinity,
              initialSelection: selectedLocation,
              dropdownMenuEntries: widget.locations
                  .map((c) => DropdownMenuEntry(label: c, value: c))
                  .toList(),
              onSelected: (val) => setState(() => selectedLocation = val),
              label: const Text('Location'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submitUpdate, child: Text('Update')),
      ],
    );
  }
}
