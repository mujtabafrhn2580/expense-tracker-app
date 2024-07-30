import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/extensions/datetime.dart';
import 'package:expense_tracker/extensions/round.dart';
import 'package:expense_tracker/Provider/total_expense_provider.dart';
import 'package:expense_tracker/Provider/expense_provider.dart';

class ExpenseTile extends ConsumerWidget {
  const ExpenseTile({
    super.key,
    required this.expenseItems,
  });

  final List<ExpenseModel> expenseItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalEpenses = ref.watch(totalExpenseProvider);
    return ListView.builder(
        itemCount: expenseItems.length,
        itemBuilder: (ctx, index) {
          final tileData = expenseItems[index];
          return Dismissible(
            key: ValueKey(tileData.id),
            background: Card(
              child: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(colors: [
                      Colors.red,
                      Colors.red.withOpacity(0.9),
                    ]),
                  ),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete_sweep_outlined),
                        SizedBox(
                          width: 8,
                        )
                      ])),
            ),
            onDismissed: (direction) {
              ref
                  .read(asyncExpenseNotifier.notifier)
                  .removeExpense(expenseItems[index], context);
            },
            child: Card(
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: expenseCategoryIconColors[tileData.category],
                  child: Icon(expenseCategoryIcons[tileData.category]),
                ),
                title: Text(
                  tileData.title,
                  style: const TextStyle(fontSize: 20, letterSpacing: -0.5),
                ),
                subtitle: Text(
                  tileData.date.dateTime.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '\$',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 11.5),
                        ),
                        TextSpan(
                          text: expenseItems[index]
                              .amount
                              .roundPercentage()
                              .toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                      ]),
                    ),
                    Text(
                      '${(tileData.amount / totalEpenses * 100).roundPercentage()}%',
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
