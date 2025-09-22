import 'package:flutter/material.dart';
import 'package:homely/model/inventory_item.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrollableDialog extends StatelessWidget {
  const ScrollableDialog({required this.child, super.key});
  final InventoryItem child;

  @override
  Widget build(BuildContext context) {
    final details = [
      ['Quantity', '${child.quantity} ${child.unit}'],
      ['Category', child.category],
      ['Location', child.location],
      ['Updated by', child.updatedBy],
      ['Last updated', child.lastUpdated.toString()],
    ];

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6, // 60% of screen
          maxWidth: 400, // keep dialog neat
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      child.name,
                      style: GoogleFonts.robotoFlex(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () {},
                    ),
                  ],
                ),
                ...details
                    .map(
                      (row) => ListTile(
                        title: Text(row[0], style: GoogleFonts.robotoFlex()),
                        subtitle: Text(row[1]),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
