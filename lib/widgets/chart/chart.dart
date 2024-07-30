import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/Provider/expense_provider.dart';
import 'package:expense_tracker/Provider/expenses_per_category_provider.dart';
import 'package:expense_tracker/models/expense_model.dart';

class Chart extends ConsumerStatefulWidget {
  const Chart({super.key});

  @override
  ConsumerState<Chart> createState() => _ChartState();
}

class _ChartState extends ConsumerState<Chart> {
  @override
  Widget build(BuildContext context) {
    final maxTotalExpense =
        ref.watch(asyncExpenseNotifier.notifier).maxTotalExpense();

    final List<double> expensePerCategory =
        ref.watch(expensePerCategoryProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          width: double.infinity,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: 175,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final category in ExpenseCategory.values)
                      ChartBar(
                        color: expenseCategoryIconColors[category]!,
                        fill: maxTotalExpense == 0
                            ? 0.1
                            : expensePerCategory[category.index] /
                                maxTotalExpense,
                      )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final category in ExpenseCategory.values)
                    Icon(expenseCategoryIcons[category]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
