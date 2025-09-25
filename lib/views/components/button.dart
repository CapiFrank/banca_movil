import 'package:flutter/material.dart';

enum ButtonState { normal, hover, pressed, focused }

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.child,
    required this.onPressed,
    this.decorationBuilder,
    this.textStyleBuilder,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final VoidCallback onPressed;

  /// Devuelve el `BoxDecoration` en función del estado
  final BoxDecoration Function(ButtonState state)? decorationBuilder;

  /// Devuelve el `TextStyle` en función del estado
  final TextStyle Function(ButtonState state)? textStyleBuilder;

  final EdgeInsetsGeometry padding;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  ButtonState get _state {
    if (_isPressed) return ButtonState.pressed;
    if (_isHovered) return ButtonState.hover;
    if (_isFocused) return ButtonState.focused;
    return ButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowFocusHighlight: (focused) => setState(() => _isFocused = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _isPressed = false;
        }),
        child: GestureDetector(
          onTap: widget.onPressed,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: widget.padding,
            decoration: widget.decorationBuilder?.call(_state),
            child: DefaultTextStyle(
              style: widget.textStyleBuilder?.call(_state) ?? const TextStyle(),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
