import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/camera/presentation/pages/camera_page.dart';
import '../../../../features/expense_tracker/presentation/bloc/expense_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LedgerLens')),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return const Center(
                child: Text('No expenses yet. Start scanning!'),
              );
            }
            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];
                final category = state.categories.firstWhere(
                  (c) => c.id == expense.categoryId,
                  orElse: () => state.categories.first,
                );
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(category.colorValue),
                    child: Icon(
                      IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(expense.merchant),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(expense.date)} - ${category.name}',
                  ),
                  trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                );
              },
            );
          } else if (state is ExpenseError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const CameraPage()));
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
