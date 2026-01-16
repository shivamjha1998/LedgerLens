import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.merchant,
    required super.date,
    required super.categoryId,
    super.receiptPath,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      merchant: json['merchant'] as String,
      date: DateTime.parse(json['date'] as String),
      categoryId: json['category_id'] as String,
      receiptPath: json['receipt_path'] as String?,
    );
  }

  /// JSON map for database (storing DateTime as ISO8601 string)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'merchant': merchant,
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'receipt_path': receiptPath,
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      merchant: expense.merchant,
      date: expense.date,
      categoryId: expense.categoryId,
      receiptPath: expense.receiptPath,
    );
  }
}
