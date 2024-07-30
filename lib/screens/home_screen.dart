import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/Provider/expense_provider.dart';

import 'package:expense_tracker/Provider/total_expense_provider.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/homeScreen/total_expense_title.dart';
import 'package:expense_tracker/widgets/homeScreen/expense_tile.dart';
import 'package:expense_tracker/widgets/homeScreen/data_per_category.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  //This will show the addExpensescreen
  void _showAddScreen(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (ctx) => const AddExpenseScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseItems = ref.watch(asyncExpenseNotifier);
    return expenseItems.when(
        error: (error, stackTrace) => Scaffold(
              body: Center(
                child: Text(error.toString()),
              ),
            ),
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            ),
        data: (data) {
          if (data.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Please add Expense'),
                actions: [
                  IconButton(
                    onPressed: () {
                      _showAddScreen(context);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              body: const Center(child: Text('No Expenses Added')),
            );
          }
          final totalExpense = ref.watch(totalExpenseProvider);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: data.isEmpty
                  ? const Text('Please add Expense')
                  : const TotalExpenseTitle(),
              actions: [
                IconButton(
                  onPressed: () {
                    _showAddScreen(context);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: data.isEmpty
                ? const Center(
                    child: Text('No Expenses'),
                  )
                : SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (final category in ExpenseCategory.values)
                                DataPerCategory(
                                    category: category,
                                    totalExpense: totalExpense,
                                    index: category.index),
                            ],
                          ),
                        ),
                        const Chart(),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ExpenseTile(
                            expenseItems: data.reversed.toList(),
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
