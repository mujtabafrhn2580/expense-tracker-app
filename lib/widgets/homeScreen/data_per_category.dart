import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/Provider/expenses_per_category_provider.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/extensions/capatilize.dart';
import 'package:expense_tracker/extensions/round.dart';

class DataPerCategory extends ConsumerWidget {
  const DataPerCategory(
      {super.key,
      required this.category,
      required this.totalExpense,
      required this.index});
  final double totalExpense;

  final ExpenseCategory category;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensePerCategory = ref.watch(expensePerCategoryProvider);
    final amount = expensePerCategory[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 3,
        ),
        height: 70,
        width: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(60, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.name.capitalize,
              style: const TextStyle(color: Colors.white),
            ),
            if (amount != 0)
              Text('\$${amount.roundPercentage().toString()}',
                  style: const TextStyle(color: Colors.white)),
            if (amount != 0)
              Text(
                '${(amount / totalExpense * 100).roundPercentage()}%',
                style: const TextStyle(color: Colors.white),
              )
          ],
        ),
      ),
    );
  }
}
