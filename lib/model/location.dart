class Location {
  Location.empty()
      : id = 0,
        name = '';
  final int id;
  final String name;

  Location({required this.id, required this.name});

  @override
  bool operator ==(Object other) => other is Location && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['location_id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_id': id,
      'name': name,
    };
  }
}
