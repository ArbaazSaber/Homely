class Category {
  Category.empty()
      : id = 0,
        name = '';
  final int id;
  final String name;

  Category({required this.id, required this.name});

  @override
  bool operator ==(Object other) => other is Category && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id,
      'name': name,
    };
  }
}
