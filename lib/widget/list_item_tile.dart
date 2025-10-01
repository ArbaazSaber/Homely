import 'package:flutter/material.dart';
import 'package:homely/model/category.dart';
import 'package:homely/model/inventory_item.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:homely/model/location.dart';
import 'package:homely/model/user.dart';
import 'package:homely/widget/add_update_dialog.dart';
import 'package:homely/widget/scrollable_dialog.dart';

class ListItemTile extends StatelessWidget {
  final InventoryItem item;
  final List<Category> allCategories;
  final List<Location> allLocations;

  const ListItemTile(this.item, {required this.allCategories, required this.allLocations, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.name,
        style: GoogleFonts.robotoFlex(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Quantity: ${item.quantity} ${item.unit}\nCategory: ${item.category.name}',
      ),
      trailing: Text(
        item.location.name,
        style: GoogleFonts.robotoFlex(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      isThreeLine: true,
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) => ScrollableDialog(child: item),
      ),
      onLongPress: () => showDialog(
        context: context,
        builder: (BuildContext context) => AddUpdateDialog(
          function: 'Update',
          item: item,
          categories: allCategories,
          locations: allLocations,
          currentUser: User.empty(),
        ),
      ),
    );
  }
}
