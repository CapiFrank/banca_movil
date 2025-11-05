import 'package:flutter/material.dart';

/// A widget that displays a fallback message when the content is empty.
/// If `isEmpty` is false, it shows the provided [child].
class EmptyStateHandler extends StatelessWidget {
  final bool isEmpty;
  final String emptyMessage;
  final Widget child;

  const EmptyStateHandler({
    super.key,
    required this.isEmpty,
    required this.emptyMessage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return _EmptyMessage(text: emptyMessage);
    }
    return child;
  }
}

/// Internal private widget to render the fallback empty message.
class _EmptyMessage extends StatelessWidget {
  final String text;

  const _EmptyMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
      ),
    );
  }
}
