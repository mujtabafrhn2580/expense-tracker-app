import 'package:flutter/material.dart';

class IconKeyboardKey extends StatelessWidget {
  const IconKeyboardKey({
    super.key,
    required this.keyicon,
    required this.keycolor,
    required this.iconColor,
    required this.onTap,
  });

  final IconData keyicon;
  final Color keycolor;
  final Color iconColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: keycolor,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: keycolor),
          width: 80,
          height: 80,
          child: Center(
              child: Icon(
            keyicon,
            color: iconColor,
          )),
        ),
      ),
    );
  }
}
