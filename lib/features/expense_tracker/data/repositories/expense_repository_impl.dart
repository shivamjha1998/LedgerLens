import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Expense>> getExpenses() async {
    final expenses = await localDataSource.getExpenses();
    return expenses; // ExpenseModel extends Expense, so this works
  }

  @override
  Future<List<Category>> getCategories() async {
    final categories = await localDataSource.getCategories();
    return categories;
  }

  @override
  Future<void> addExpense(Expense expense) async {
    final model = ExpenseModel.fromEntity(expense);
    await localDataSource.addExpense(model);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
  }
}
