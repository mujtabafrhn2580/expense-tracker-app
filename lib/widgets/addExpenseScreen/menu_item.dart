import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, required this.category});
  final ExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: expenseCategoryIconColors[category],
          child: Icon(expenseCategoryIcons[category]),
        ),
        const SizedBox(width: 20),
        Text(category.name)
      ],
    );
  }
}
