class Family {
  Family.empty()
      : id = 0,
        name = '',
        createdAt = DateTime.now();
  final int id;
  final String name;
  final DateTime createdAt;

  Family({required this.id, required this.name, required this.createdAt});

  @override
  bool operator ==(Object other) => other is Family && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['family_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'family_id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
