import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/Provider/amount_provider.dart';
import 'package:expense_tracker/Provider/expense_provider.dart';
import 'package:expense_tracker/widgets/keyboard/keyboard.dart';
import 'package:expense_tracker/widgets/addExpenseScreen/menu_item.dart';
import 'package:expense_tracker/widgets/addExpenseScreen/amount_display.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/extensions/datetime.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  bool isDropDown = false;
  DateTime? _selectedDate;
  late String title;
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  final TextEditingController _titleController = TextEditingController();

  //This function to get the newly entered amount of expense
  double enteredAmount(String amount) {
    if (amount.isEmpty) {
      return 0;
    }
    return double.parse(amount);
  }

  @override
  Widget build(BuildContext context) {
    final String amount = ref.watch(amountProvider);

    //This functiion is sent to keyboard to getdate from date picker;
    void getdate(DateTime date) {
      setState(() {
        _selectedDate = date;
      });
    }

    //This function save all the expense
    void saveExpense() {
      final tempTitle = _titleController.text;
      final tempAmount = enteredAmount(amount);
      if (tempAmount == 0 || _selectedDate == null || tempTitle == '') {
        ScaffoldMessenger.of(context).clearMaterialBanners();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill form'),
          behavior: SnackBarBehavior.floating,
        ));
        return;
      }
      ref.read(asyncExpenseNotifier.notifier).addExpense(ExpenseModel(
          title: tempTitle,
          amount: tempAmount,
          category: _selectedCategory,
          date: _selectedDate!));
      ref.read(amountProvider.notifier).onSave();
      Navigator.of(context).pop();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 2.5),
            child: Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: _selectedCategory,
                    icon: isDropDown
                        ? const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 45,
                          )
                        : const Icon(Icons.keyboard_arrow_down_outlined),
                    isExpanded: true,
                    items: ExpenseCategory.values
                        .map(
                          (category) => DropdownMenuItem(
                            alignment: Alignment.center,
                            value: category,
                            child: MenuItem(
                              category: category,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
            child: TextField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              controller: _titleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Please enter title...',
                label: const Text('Title'),
                suffixIcon: IconButton(
                    onPressed: () => _titleController.clear(),
                    icon: const Icon(Icons.close)),
              ),
            ),
          ),

          AmountDisplay(amount: amount),
          //Date display
          SizedBox(
            height: 25,
            child: Text(
              _selectedDate == null
                  ? 'Please enter date...'
                  : _selectedDate!.dateTime,
              style: TextStyle(color: Colors.grey[600]!),
            ),
          ),
          Keyboard(
            savedate: getdate,
            saveExpense: saveExpense,
          )
        ],
      ),
    );
  }
}
