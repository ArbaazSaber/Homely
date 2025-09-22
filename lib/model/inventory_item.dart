class InventoryItem {
  final int id;
  final String name;
  final double quantity;
  final String unit;
  final String location;
  final String category;
  final DateTime lastUpdated = DateTime.now();
  final String updatedBy;

  InventoryItem.empty()
    : id = 0,
      name = '',
      quantity = 0,
      unit = '',
      location = '',
      category = '',
      updatedBy = '';

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.location,
    required this.category,
    required this.updatedBy,
  });
}
