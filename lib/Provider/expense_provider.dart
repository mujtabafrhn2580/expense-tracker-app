import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:expense_tracker/models/expense_model.dart';

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

  Future<void> removeExpense(ExpenseModel expense) async {
    final db = await _getDatabase();
    await db.delete(
      'user_expenses',
      where: 'id = ?',
      whereArgs: [expense.id],
    );

    state =
        AsyncValue.data(state.value!.where((p) => p.id != expense.id).toList());
  }

  Future<void> addExpense(ExpenseModel newExpense) async {
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
}

final asyncExpenseNotifier =
    AsyncNotifierProvider<AsyncExpenseNotifier, List<ExpenseModel>>(
        AsyncExpenseNotifier.new);
