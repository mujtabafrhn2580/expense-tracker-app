import 'package:expense_tracker/Provider/expense_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalExpenseProvider = Provider((ref) {
  final expenses = ref.watch(asyncExpenseNotifier).value;
  double sum = 0.00;
  if (expenses!.isNotEmpty) {
    for (final expense in expenses) {
      sum += expense.amount;
    }
  }
  return sum;
});
