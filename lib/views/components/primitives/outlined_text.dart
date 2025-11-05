import 'package:flutter/widgets.dart';

/// Texto con contorno (stroke) redondeado alrededor del texto
class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const OutlinedText(
    this.text, {
    super.key,
    this.style = const TextStyle(),
    required this.textColor,
    required this.strokeColor,
    this.strokeWidth = 2,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..strokeCap = StrokeCap
                  .round // ✅ punta redondeada
              ..strokeJoin = StrokeJoin
                  .round // ✅ esquinas redondeadas
              ..color = strokeColor,
          ),
        ),

        // Texto relleno
        Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          style: style.copyWith(color: textColor),
        ),
      ],
    );
  }
}
