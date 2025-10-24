import 'package:flutter/material.dart';

/// Descripción de una acción para ResponsiveActions.
/// - label: texto que se usará para medir ancho.
/// - iconWidth: ancho aproximado del icono (si aplica); si el botón no tiene icono, déjalo 0.
/// - horizontalPadding: padding horizontal interno del botón (izq + der).
/// - builder: recibe `fullWidth` que indica si el botón debe ocupar todo el ancho.
class ResponsiveAction {
  final String label;
  final double iconWidth;
  final double horizontalPadding;
  final Widget Function(bool fullWidth) builder;

  const ResponsiveAction({
    required this.label,
    required this.builder,
    this.iconWidth = 0.0,
    this.horizontalPadding = 16.0,
  });
}

/// Widget que muestra las acciones en fila si caben, o en columna expandida si no.
class ResponsiveActions extends StatelessWidget {
  final List<ResponsiveAction> actions;
  final double spacing; // horizontal spacing entre botones
  final double runSpacing; // vertical spacing si se vuelven a líneas
  final TextStyle? textStyle;
  final double iconSpacing; // separación entre icono y texto dentro del botón
  final double minButtonWidth; // opcional: ancho mínimo a considerar por botón

  const ResponsiveActions({
    super.key,
    required this.actions,
    this.spacing = 8,
    this.runSpacing = 8,
    this.textStyle,
    this.iconSpacing = 8,
    this.minButtonWidth = 0,
  });

  double _measureLabelWidth(
    String label,
    TextStyle style,
    double maxWidthHint,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    tp.layout(minWidth: 0, maxWidth: maxWidthHint);
    return tp.width;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        textStyle ?? Theme.of(context).textTheme.bodyMedium!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        // calcula ancho requerido por cada acción
        final List<double> requiredWidths = actions.map((a) {
          final textW = _measureLabelWidth(
            a.label,
            effectiveTextStyle,
            availableWidth,
          );
          final w =
              textW +
              a.iconWidth +
              (a.iconWidth > 0 ? iconSpacing : 0) +
              (a.horizontalPadding * 2);
          return w < minButtonWidth ? minButtonWidth : w;
        }).toList();

        final totalRequired =
            requiredWidths.fold<double>(0, (p, e) => p + e) +
            spacing * (actions.length - 1);

        final fitsInRow = totalRequired <= availableWidth;

        if (fitsInRow) {
          // mostrar fila: cada botón conserva su tamaño intrínseco
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(actions.length, (i) {
              final a = actions[i];
              return Padding(
                padding: EdgeInsets.only(
                  right: i == actions.length - 1 ? 0 : spacing,
                ),
                child: IntrinsicWidth(
                  // el IntrinsicWidth evita que el contenido se expanda innecesariamente
                  child: a.builder(false),
                ),
              );
            }),
          );
        } else {
          // no caban: mostrar columna, cada botón ocupa todo el ancho disponible
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(actions.length, (i) {
              final index = actions.length - 1 - i;
              final a = actions[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i == actions.length - 1 ? 0 : runSpacing,
                ),
                child: SizedBox(width: double.infinity, child: a.builder(true)),
              );
            }),
          );
        }
      },
    );
  }
}
