import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import 'package:homely/data/inventory_items.dart';
import 'package:homely/model/inventory_item.dart';
import 'package:homely/widget/list_item_tile.dart';
import 'package:homely/widget/add_update_dialog.dart';

class InvetoryScreen extends StatefulWidget {
  const InvetoryScreen({super.key});

  @override
  State<InvetoryScreen> createState() => _InvetoryScreenState();
}

class _InvetoryScreenState extends State<InvetoryScreen> {
  Widget appBarTitle = const Text('Inventory Screen');
  bool isSearchMode = false;
  late TextEditingController _searchController;

  List<InventoryItem> filteredItems = dummyInventoryItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       filteredItems = dummyInventoryItems;
  //     });
  //   } else {
  //     setState(() {
  //       filteredItems = dummyInventoryItems
  //           .where(
  //             (item) =>
  //                 item.name.toLowerCase().contains(query.toLowerCase()) ||
  //                 item.category.toLowerCase().contains(query.toLowerCase()) ||
  //                 item.location.toLowerCase().contains(query.toLowerCase()),
  //           )
  //           .toList();
  //     });
  //   }
  // }

  void filterSearchResults(String query) {
    final q = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredItems = dummyInventoryItems;
      });
      return;
    }
    setState(() {
      filteredItems = dummyInventoryItems.where((item) {
        final String itemName = item.name.toLowerCase();
        if (itemName.contains(q)) return true; // Exact match found

        // Fuzzy match check
        final nameScore = partialRatio(itemName, q);

        int threshold = q.length < 4 ? 70 : 85;
        
        return nameScore >= threshold; // Adjust threshold as needed
      }).toList();
    });
  }

  void openSearch() {
    setState(() {
      isSearchMode = true;
      appBarTitle = TextField(
        autofocus: true,
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
        ),
        onChanged: filterSearchResults,
      );
    });
  }

  void closeSearch() {
    setState(() {
      isSearchMode = false;
      _searchController.clear();
      filteredItems = dummyInventoryItems; // reset full list
      appBarTitle = const Text('Inventory Screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: Colors.deepPurple.shade200,
        actions: [
          isSearchMode
              ? IconButton(
                  onPressed: closeSearch,
                  icon: const Icon(Icons.close),
                )
              : IconButton(
                  onPressed: openSearch,
                  icon: const Icon(Icons.search),
                ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_alt)),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListItemTile(filteredItems[index]);
        },
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
