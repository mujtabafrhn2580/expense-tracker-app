import 'package:expense_tracker/Provider/amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyboardKey extends ConsumerWidget {
  const KeyboardKey({
    super.key,
    required this.number,
    required this.keycolor,
  });

  final String number;
  final Color keycolor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: InkWell(
        splashColor: keycolor,
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          ref.read(amountProvider.notifier).onNumberTapped(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: keycolor),
            width: 80,
            height: 80,
            child: Center(
                child: Text(
              number,
              style: const TextStyle(color: Colors.black, fontSize: 30),
            )),
          ),
        ),
      ),
    );
  }
}
