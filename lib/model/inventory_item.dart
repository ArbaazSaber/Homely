import 'package:homely/model/family.dart';
import 'package:homely/model/location.dart';
import 'package:homely/model/category.dart';
import 'package:homely/model/user.dart';

class InventoryItem {
  final int id;
  final String name;
  final double quantity;
  final String unit;
  final Category category;
  final Location location;
  final Family family;
  final DateTime lastUpdated;
  final User updatedBy;
  final bool isReplenishable;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.location,
    required this.family,
    required this.lastUpdated,
    required this.updatedBy,
    required this.isReplenishable,
  });

  InventoryItem.empty()
      : id = 0,
        name = '',
        quantity = 0.0,
        unit = '',
        category = Category.empty(),
        location = Location.empty(),
        family = Family.empty(),
        lastUpdated = DateTime.now(),
        updatedBy = User.empty(),
        isReplenishable = false;

  @override
  bool operator ==(Object other) => other is InventoryItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['item_id'] as int,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: Category.fromJson(json['category']),
      location: Location.fromJson(json['location']),
      family: Family.fromJson(json['family']),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      updatedBy: User.fromJson(json['updated_by']),
      isReplenishable: json['is_replenishable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'location': location,
      'family': family,
      'last_updated': lastUpdated.toIso8601String(),
      'updated_by': updatedBy,
      'is_replenishable': isReplenishable,
    };
  }
}
