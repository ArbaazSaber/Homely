import 'package:homely/model/family.dart';

class User {
  User.empty()
      : id = 0,
        name = '',
        code = '',
        createdAt = DateTime.now(),
        family = Family.empty();
  final int id;
  final String name;
  final String code;
  final DateTime createdAt;
  final Family family;

  User({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.family,
  });

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['created_at']),
      family: Family.fromJson(json['family']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'code': code,
      'created_at': createdAt.toIso8601String(),
      'family_id': family.id,
    };
  }
}
