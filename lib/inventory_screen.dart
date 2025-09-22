import 'package:flutter/material.dart';
import 'package:homely/data/inventory_items.dart';
import 'package:homely/model/inventory_item.dart';
import 'package:homely/widget/list_item_tile.dart';

import 'package:homely/widget/add_update_dialog.dart';

class InvetoryScreen extends StatelessWidget {
  const InvetoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Screen'),
        backgroundColor: Colors.deepPurple.shade200,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_alt)),
        ],
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: dummyInventoryItems.length,
          itemBuilder: (context, index) {
            return ListItemTile(dummyInventoryItems[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) => AddUpdateDialog(
          function: 'Add',
          item: InventoryItem.empty(),
          categories: allCategories,
          locations: allLocations,
        ),
      ),
        tooltip: 'Add Item',
        backgroundColor: Colors.deepPurple.shade200,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
