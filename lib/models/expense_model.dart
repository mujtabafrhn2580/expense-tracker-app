import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

//Icons for diffrent expense categories
Map<ExpenseCategory, IconData> expenseCategoryIcons = {
  ExpenseCategory.work: Icons.laptop_chromebook_outlined,
  ExpenseCategory.entertainment: Icons.sports_esports_outlined,
  ExpenseCategory.transportation: Icons.directions_car_outlined,
  ExpenseCategory.food: Icons.local_dining_outlined,
};
//IconColors for different icons
Map<ExpenseCategory, Color> expenseCategoryIconColors = {
  ExpenseCategory.work: Colors.lightBlueAccent,
  ExpenseCategory.entertainment: Colors.greenAccent,
  ExpenseCategory.transportation: Colors.purpleAccent,
  ExpenseCategory.food: Colors.pinkAccent,
};

//Expenses Categories
enum ExpenseCategory {
  work,
  food,
  transportation,
  entertainment,
}

const uuid = Uuid();

class ExpenseModel {
   ExpenseModel({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }): id = uuid.v6();

  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String id;
}

//To get expenses per Category
class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<ExpenseModel> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final ExpenseCategory category;
  final List<ExpenseModel> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}

final List<ExpenseModel> dummyData = [
  ExpenseModel(
    amount: 20,
    title: 'Laptop',
    category: ExpenseCategory.work,
    date: DateTime(2017, 8, 13, 3),
  ),
  ExpenseModel(
    amount: 40,
    title: 'Burger',
    category: ExpenseCategory.food,
    date: DateTime(2017, 8, 13, 3),
  ),
  ExpenseModel(
    amount: 20,
    title: 'XBox 360',
    category: ExpenseCategory.entertainment,
    date: DateTime(2017, 8, 13, 3),
  ),
  ExpenseModel(
    amount: 10,
    title: 'Busfair',
    category: ExpenseCategory.transportation,
    date: DateTime(2017, 8, 13, 3),
  ),
];
