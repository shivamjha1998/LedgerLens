import '../entities/expense.dart';
import '../entities/category.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<List<Category>> getCategories();
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
