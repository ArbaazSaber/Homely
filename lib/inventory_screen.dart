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

  Set<String> selectedCategories = allCategories.toSet();
  Set<String> selectedLocations = allLocations.toSet();
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

  void filterItems() {
    final q = _searchController.text.toLowerCase();

    bool matchesItem(InventoryItem item) =>
      selectedCategories.contains(item.category) &&
      selectedLocations.contains(item.location) &&
      (q.isEmpty || 
        item.name.toLowerCase().contains(q) || 
        partialRatio(item.name.toLowerCase(), q) >= (q.length < 4 ? 70 : 85));

    setState(() {
      filteredItems = dummyInventoryItems.where(matchesItem).toList();
    });
  }

  void applyFilter() {
    filterItems();
    Navigator.of(context).pop(); // Close the dialog
  }

  void toggleSelection(
    Set<String> set,
    String value,
    void Function(void Function()) setStateDialog,
  ) {
    setStateDialog(() {
      if (set.contains(value)) {
        set.remove(value);
      } else {
        set.add(value);
      }
    });
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Filter Items"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Category"),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected:
                            selectedCategories.length == allCategories.length,
                        onSelected: (bool selected) {
                          setStateDialog(() {
                            if (selected) {
                              selectedCategories = allCategories.toSet();
                            } else {
                              selectedCategories.clear();
                            }
                          });
                        },
                      ),
                      ...allCategories.map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: selectedCategories.contains(category),
                          onSelected: (bool selected) => toggleSelection(
                            selectedCategories,
                            category,
                            setStateDialog,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Location"),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected:
                            selectedLocations.length == allLocations.length,
                        onSelected: (bool selected) {
                          setStateDialog(() {
                            if (selected) {
                              selectedLocations = allLocations.toSet();
                            } else {
                              selectedLocations.clear();
                            }
                          });
                        },
                      ),
                      ...allLocations.map((location) {
                        return FilterChip(
                          label: Text(location),
                          selected: selectedLocations.contains(location),
                          onSelected: (bool selected) => toggleSelection(
                            selectedLocations,
                            location,
                            setStateDialog,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(onPressed: applyFilter, child: Text('Filter')),
            ],
          );
        },
      ),
    );
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
        onChanged: (String query) => filterItems(),
      );
    });
  }

  void closeSearch() {
    setState(() {
      isSearchMode = false;
      _searchController.clear();
      filterItems();
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
          IconButton(
            onPressed: showFilterDialog,
            icon: const Icon(Icons.filter_list_alt),
          ),
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
