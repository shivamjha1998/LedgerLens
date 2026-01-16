part of 'expense_bloc.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final List<Category> categories;
  final double totalSpent;

  const ExpenseLoaded({
    required this.expenses,
    required this.categories,
    required this.totalSpent,
  });

  @override
  List<Object> get props => [expenses, categories, totalSpent];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object> get props => [message];
}
