import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/expense_repository.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc({required this.repository}) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await repository.getExpenses();
      final categories = await repository.getCategories();

      double total = 0;
      for (var e in expenses) {
        total += e.amount;
      }

      emit(
        ExpenseLoaded(
          expenses: expenses,
          categories: categories,
          totalSpent: total,
        ),
      );
    } catch (e) {
      emit(ExpenseError("Failed to load expenses: $e"));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.addExpense(event.expense);
      add(LoadExpenses()); // Reload to refresh list
    } catch (e) {
      emit(ExpenseError("Failed to add expense: $e"));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await repository.deleteExpense(event.id);
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError("Failed to delete expense: $e"));
    }
  }
}
