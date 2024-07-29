import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/widgets/keyboard/keyboard_key.dart';
import 'package:expense_tracker/widgets/keyboard/icon_keyboard_key.dart';
import 'package:expense_tracker/Provider/amount_provider.dart';

class Keyboard extends ConsumerWidget {
  const Keyboard(
      {super.key, required this.savedate, required this.saveExpense});

  final void Function() saveExpense;
  final void Function(DateTime date) savedate;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //This is for calender button to show date picker
    void pickdate() async {
      final now = DateTime.now();
      final firstDate = DateTime(now.year, now.month - 1, now.weekday);
      final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: now,
        initialDate: now,
      );
      if (pickedDate != null) {
        savedate(pickedDate);
      }
    }

    //This is for backSpacebutton
    void callNotifier() {
      ref.read(amountProvider.notifier).onCancelText();
    }

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeyboardKey(number: '1', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '4', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '7', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '\$', keycolor: Colors.yellow[100]!),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeyboardKey(number: '2', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '5', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '8', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '0', keycolor: Colors.grey[300]!),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeyboardKey(number: '3', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '6', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '9', keycolor: Colors.grey[300]!),
              KeyboardKey(number: '.', keycolor: Colors.grey[300]!),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconKeyboardKey(
                keyicon: Icons.backspace,
                keycolor: const Color.fromARGB(255, 255, 155, 148),
                iconColor: Colors.black87,
                onTap: () {
                  callNotifier();
                },
              ),
              GestureDetector(
                onTap: () {},
                child: IconKeyboardKey(
                  keyicon: Icons.calendar_month,
                  keycolor: const Color.fromARGB(255, 158, 211, 255),
                  iconColor: Colors.black,
                  onTap: () {
                    pickdate();
                  },
                ),
              ),
              Expanded(
                child: IconKeyboardKey(
                  keyicon: Icons.check,
                  keycolor: const Color.fromARGB(255, 15, 15, 15),
                  iconColor: Colors.white,
                  onTap: saveExpense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
