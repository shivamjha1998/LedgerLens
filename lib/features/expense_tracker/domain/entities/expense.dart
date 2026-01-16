import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final String merchant;
  final DateTime date;
  final String categoryId;
  final String? receiptPath;

  const Expense({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.date,
    required this.categoryId,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    merchant,
    date,
    categoryId,
    receiptPath,
  ];
}
