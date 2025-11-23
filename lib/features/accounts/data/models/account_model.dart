import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String id;
  final String name;
  final String type; // 'Cash', 'Bank', etc.
  final double balance;
  final String? icon;
  final String? color;

  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.icon,
    this.color,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['\$id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'Cash',
      balance: (map['balance'] ?? 0).toDouble(),
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'balance': balance,
      'icon': icon,
      'color': color,
    };
  }

  @override
  List<Object?> get props => [id, name, type, balance, icon, color];
}
