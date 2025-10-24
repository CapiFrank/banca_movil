import 'package:flutter/material.dart';

class IntrinsicSize extends StatelessWidget {
  final Widget child;
  const IntrinsicSize({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(child: IntrinsicHeight(child: child));
  }
}
