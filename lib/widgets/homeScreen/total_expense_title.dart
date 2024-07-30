import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/Provider/total_expense_provider.dart';
import 'package:expense_tracker/extensions/round.dart';

class TotalExpenseTitle extends ConsumerWidget {
  const TotalExpenseTitle({super.key});
  double roundToTwoDecimalPlaces(double value) {
    return (value * 100).round() / 100;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalExpense =
        roundToTwoDecimalPlaces(ref.watch(totalExpenseProvider));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(children: [
            const TextSpan(text: '\$', style: TextStyle(color: Colors.grey)),
            TextSpan(
              text: totalExpense.roundPercentage().toString(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  fontSize: 29,
                  height: 0.9),
            )
          ]),
        ),
        Text(
          'Total Expenses',
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
