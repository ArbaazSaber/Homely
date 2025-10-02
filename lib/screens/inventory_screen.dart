import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:homely/model/category.dart';
import 'package:homely/model/user.dart' as userModel;
import 'package:homely/model/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:homely/model/inventory_item.dart';
import 'package:homely/widget/list_item_tile.dart';
import 'package:homely/widget/add_update_dialog.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen(this.user, {super.key});

  final userModel.User user;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final supabase = Supabase.instance.client;

  late List<Category> allCategories;
  late List<Location> allLocations;
  late List<InventoryItem> allItems;
  late Set<Category> selectedCategories;
  late Set<Location> selectedLocations;
  late Set<InventoryItem> filteredItems;

  late TextEditingController _searchController;
  
  Widget appBarTitle = const Text('Inventory Screen');
  bool _isSearchMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategoriesAndLocations();
    loadItems();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void loadCategoriesAndLocations() async {
    try {
      final responseCategories = await supabase.from('categories').select();
      final responseLocations = await supabase.from('locations').select();

      if (mounted) {
        setState(() {
          allCategories = List<Category>.from(
            responseCategories.map((e) => Category.fromJson(e)),
          );
          allLocations = List<Location>.from(
            responseLocations.map((e) => Location.fromJson(e)),
          );
          selectedCategories = allCategories.toSet();
          selectedLocations = allLocations.toSet();
        });
      }
    } catch (e) {
      print('Error loading categories and locations: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void loadItems() async {
    try {
      final responseItems = await supabase
      .from('inventory_items')
      .select('''
        *,
        category:categories(name, category_id),
        location:locations(name, location_id),
        family:families(*),
        updated_by:users(*, family:families(*))
      ''')
      .eq('family_id', widget.user.family.id);
      
      if (responseItems.isEmpty) {
        print('No items found or response is null');
        if (mounted) {
          setState(() {
            allItems = [];
            filteredItems = {};
            _isLoading = false;
          });
        }
        return;
      }
      
      if (mounted) {
        setState(() {
          allItems = responseItems.map((e) {
            try {
              return InventoryItem.fromJson(e);
            } catch (e) {
              print('Error parsing item: $e');
              return null;
            }
          }).whereType<InventoryItem>().toList();
          
          filteredItems = allItems.toSet();
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading items: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void filterItems() {
    final q = _searchController.text.toLowerCase();

    bool matchesItem(InventoryItem item) =>
        selectedCategories.contains(item.category) &&
        selectedLocations.contains(item.location) &&
        (q.isEmpty ||
            item.name.toLowerCase().contains(q) ||
            partialRatio(item.name.toLowerCase(), q) >=
                (q.length < 4 ? 70 : 85));

    setState(() {
      filteredItems = allItems.where(matchesItem).toSet();
    });
  }

  void applyFilter() {
    filterItems();
    Navigator.of(context).pop(); // Close the dialog
  }

  void toggleSelection<T>(
    Set<T> set,
    T value,
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
                          label: Text(category.name),
                          selected: selectedCategories.contains(category),
                          onSelected: (bool selected) =>
                              toggleSelection<Category>(
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
                          label: Text(location.name),
                          selected: selectedLocations.contains(location),
                          onSelected: (bool selected) =>
                              toggleSelection<Location>(
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
      _isSearchMode = true;
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
      _isSearchMode = false;
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
          _isSearchMode
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : allItems.isEmpty
              ? const Center(child: Text('No items found'))
              :
      ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListItemTile(
            filteredItems.toList()[index],
            allCategories: allCategories,
            allLocations: allLocations,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AddUpdateDialog(
            function: 'Add',
            item: InventoryItem.empty(),
            categories: allCategories,
            locations: allLocations, currentUser: userModel.User.empty(),
          ),
        ),
        tooltip: 'Add Item',
        backgroundColor: Colors.deepPurple.shade200,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
