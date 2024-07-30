import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:expense_tracker/models/expense_model.dart';

//Function to get database
Future<Database> _getDatabase() async {
  final databasePath = await sql.getDatabasesPath();

  final db = await sql.openDatabase(
    path.join(databasePath, 'expenses.db'),
    onCreate: (db, version) => db.execute(
        'CREATE TABLE user_expenses(id TEXT PRIMARY KEY, title TEXT, category TEXT, amount REAL, date Text)'),
    version: 1,
  );
  return db;
}

//This function is to concert category to enum
ExpenseCategory categoryFromString(String categoryString) {
  switch (categoryString.toLowerCase()) {
    case 'food':
      return ExpenseCategory.food;
    case 'work':
      return ExpenseCategory.work;
    case 'entertainment':
      return ExpenseCategory.entertainment;
    case 'transportation':
      return ExpenseCategory.transportation;
    default:
      throw ArgumentError('Unknown category: $categoryString');
  }
}

class AsyncExpenseNotifier extends AsyncNotifier<List<ExpenseModel>> {
  @override
  Future<List<ExpenseModel>> build() async {
    return loadExpenses(); // Your async result
  }

  Future<List<ExpenseModel>> loadExpenses() async {
    final db = await _getDatabase();
    final data = await db.query('user_expenses');
    final expenses = data.map((row) {
      final date = DateTime.parse(row['date'] as String);
      final category = categoryFromString(row['category'] as String);
      return ExpenseModel(
        title: row['title'] as String,
        amount: row['amount'] as double,
        category: category,
        date: date,
        // Initialize other fields as needed
      );
    }).toList();

    return expenses;
  }

  Future<void> removeExpense(ExpenseModel expense, context) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> results = await db.query('user_expenses');

    // Print each row
    for (final row in results) {
      print(row);
    }
    await db.delete(
      'user_expenses',
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    print(
        'Notice this is the id that should be deleted ${expense.id.toString()}');

    state =
        AsyncValue.data(state.value!.where((p) => p.id != expense.id).toList());

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            print('something should happen');

            await db.insert('user_expenses', {
              'title': expense.title,
              'id': expense.id,
              'amount': expense.amount,
              'category': expense.category.name,
              'date': expense.date.toString(),
            });

            state = AsyncValue.data([
              ...state.value!,
              expense,
            ]);
          },
        ),
      ),
    );
  }

  Future<void> addExpense(ExpenseModel newExpense) async {
    print('This is The id of when the expense is saved ${newExpense.id}');
    final db = await _getDatabase();
    db.insert('user_expenses', {
      'title': newExpense.title,
      'id': newExpense.id,
      'amount': newExpense.amount,
      'category': newExpense.category.name,
      'date': newExpense.date.toString(),
    });

    state = state.whenData((expenses) => [...expenses, newExpense]);
  }

  //The total expense of the category with highest total expense
  double maxTotalExpense() {
    final List<double> expensePerCategory = [
      for (final category in ExpenseCategory.values)
        ExpenseBucket.forCategory(state.value!, category).totalExpenses,
    ];
    double max = 0;
    for (final totalExpense in expensePerCategory) {
      if (totalExpense > max) {
        max = totalExpense;
      }
    }
    return max;
  }

  Future<void> _removeExpense(ExpenseModel expense, context) async {
    final db = await _getDatabase();
    final expenseIndex = state.value!.indexOf(expense);

    state.value!.remove(expense);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            state.value!.insert(expenseIndex, expense);
            db.insert('user_expenses', {
              'title': expense.title,
              'id': expense.id,
              'amount': expense.amount,
              'category': expense.category.name,
              'date': expense.date.toString(),
            });
          },
        ),
      ),
    );
  }
}

final asyncExpenseNotifier =
    AsyncNotifierProvider<AsyncExpenseNotifier, List<ExpenseModel>>(
        AsyncExpenseNotifier.new);
