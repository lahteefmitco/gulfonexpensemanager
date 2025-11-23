import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String type; // 'Income', 'Expense'
  final String? icon;
  final String? color;
  final String? parentId; // For sub-categories

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.parentId,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['\$id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Expense',
      icon: map['icon'],
      color: map['color'],
      parentId: map['parentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
      'parentId': parentId,
    };
  }

  @override
  List<Object?> get props => [id, name, type, icon, color, parentId];
}
