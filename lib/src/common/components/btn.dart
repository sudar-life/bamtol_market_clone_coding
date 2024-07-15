import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final EdgeInsets padding;
  final Color color;
  final bool disabled;
  const Btn({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
    this.color = const Color(0xffED7738),
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!disabled) {
          onTap();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: padding,
          color: disabled ? Colors.grey : color,
          child: child,
        ),
      ),
    );
  }
}
