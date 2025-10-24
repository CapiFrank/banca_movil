import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool isFlipped;
  final VoidCallback? onFlip;
  final Duration duration;
  final Curve curve;

  const FlipCard({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.isFlipped,
    this.onFlip,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _previousFlipState = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _previousFlipState = widget.isFlipped;
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Solo animar si el estado de flip cambió
    if (widget.isFlipped != _previousFlipState) {
      _performFlip();
      _previousFlipState = widget.isFlipped;
    }
    
    // Actualizar duración y curva si cambiaron
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performFlip() {
    if (widget.isFlipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    
    // Ejecutar callback si existe
    widget.onFlip?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final isShowingFront = _animation.value < 0.5;
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_animation.value * 3.14159),
          child: isShowingFront
              ? widget.firstChild
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateX(3.14159),
                  child: widget.secondChild,
                ),
        );
      },
    );
  }
}