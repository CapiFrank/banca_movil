import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const Section({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}