import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/database_helper.dart';
import 'features/expense_tracker/data/datasources/expense_local_data_source.dart';
import 'features/expense_tracker/data/repositories/expense_repository_impl.dart';
import 'features/expense_tracker/presentation/bloc/expense_bloc.dart';
import 'features/core/presentation/pages/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection (Manual for MVP)
  final databaseHelper = DatabaseHelper();
  final localDataSource = ExpenseLocalDataSourceImpl(
    databaseHelper: databaseHelper,
  );
  final expenseRepository = ExpenseRepositoryImpl(
    localDataSource: localDataSource,
  );

  runApp(MyApp(expenseRepository: expenseRepository));
}

class MyApp extends StatelessWidget {
  final ExpenseRepositoryImpl expenseRepository;

  const MyApp({super.key, required this.expenseRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ExpenseBloc(repository: expenseRepository)..add(LoadExpenses()),
        ),
      ],
      child: MaterialApp(
        title: 'LedgerLens',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            secondary: const Color(0xFFFFC107),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
          ),
        ),
        home: const MainPage(),
      ),
    );
  }
}
