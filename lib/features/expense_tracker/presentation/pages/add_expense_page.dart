import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';

class AddExpensePage extends StatefulWidget {
  final double? initialAmount;
  final String? initialMerchant;
  final DateTime? initialDate;

  const AddExpensePage({
    super.key,
    this.initialAmount,
    this.initialMerchant,
    this.initialDate,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  late DateTime _selectedDate;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount?.toStringAsFixed(2) ?? '',
    );
    _merchantController = TextEditingController(
      text: widget.initialMerchant ?? '',
    );
    _selectedDate = widget.initialDate ?? DateTime.now();
    _applySmartDefaults();
  }

  void _applySmartDefaults() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour <= 10) {
      // Morning -> Coffee/Food (ID '1')
      _selectedCategoryId = '1';
      _merchantController.text = "Morning Coffee"; // Mock prediction
    } else if (hour >= 11 && hour <= 14) {
      // Lunch -> Food (ID '1')
      _selectedCategoryId = '1';
      _merchantController.text = "Lunch";
    } else if (hour >= 18 && hour <= 21) {
      // Dinner -> Food (ID '1')
      _selectedCategoryId = '1';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final enteredAmount = double.parse(_amountController.text);
      final enteredMerchant = _merchantController.text;

      final newExpense = Expense(
        id: const Uuid().v4(),
        amount: enteredAmount,
        merchant: enteredMerchant,
        date: _selectedDate,
        categoryId: _selectedCategoryId!,
      );

      context.read<ExpenseBloc>().add(AddExpenseEvent(newExpense));
      Navigator.of(context).pop();
    } else if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
    }
  }

  Future<void> _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is! ExpenseLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = state.categories;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _merchantController,
                      decoration: const InputDecoration(labelText: 'Merchant'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a merchant name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                          ),
                        ),
                        TextButton(
                          onPressed: _presentDatePicker,
                          child: const Text('Choose Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _selectedCategoryId,
                      hint: const Text('Select Category'),
                      items: categories.map((Category category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Row(
                            children: [
                              Icon(
                                IconData(
                                  category.iconCode,
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: Color(category.colorValue),
                              ),
                              const SizedBox(width: 10),
                              Text(category.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: const Text('Add Expense'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
