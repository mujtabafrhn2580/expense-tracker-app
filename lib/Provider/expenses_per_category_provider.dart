import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/Provider/expense_provider.dart';

final expensePerCategoryProvider = Provider<List<double>>((ref) {
  final allExpenses = ref.watch(asyncExpenseNotifier).value;
  final List<double> expenses = [
    for (final expense in ExpenseCategory.values)
      ExpenseBucket.forCategory(allExpenses!, expense).totalExpenses
  ];
  return expenses;
});
