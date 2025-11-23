import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String type; // 'Income', 'Expense', 'Transfer'
  final String categoryId;
  final String accountId;
  final String? toAccountId; // For transfers
  final DateTime date;
  final String? note;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.accountId,
    this.toAccountId,
    required this.date,
    this.note,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['\$id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'Expense',
      categoryId: map['categoryId'] ?? '',
      accountId: map['accountId'] ?? '',
      toAccountId: map['toAccountId'],
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'accountId': accountId,
      'toAccountId': toAccountId,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  @override
  List<Object?> get props =>
      [id, amount, type, categoryId, accountId, toAccountId, date, note];
}
