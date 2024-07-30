import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key, required this.amount});
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 90,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\$',
                style: TextStyle(fontSize: 40, color: Colors.grey[300]!),
              ),
              TextSpan(
                text: amount,
                style: const TextStyle(
                    fontSize: 70, color: Colors.black, letterSpacing: -4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
