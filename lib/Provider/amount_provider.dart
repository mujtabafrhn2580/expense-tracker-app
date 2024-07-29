import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmountNotifier extends StateNotifier<String> {
  AmountNotifier() : super('');
  //This is for to type in keyboard
  onNumberTapped(number) {
    if (state.length > 7) {
      return;
    }
    state += number;
  }

  //This is for the backspacefunction in keyboard
  onCancelText() {
    if (state.isNotEmpty) {
      var newvalue = state.substring(0, state.length - 1);

      state = newvalue;
    }
  }

  onSave() {
    state = '';
  }
}

final amountProvider =
    StateNotifierProvider<AmountNotifier, String>((ref) => AmountNotifier());
