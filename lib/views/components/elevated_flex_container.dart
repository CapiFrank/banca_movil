import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

enum FlexDirection { horizontal, vertical }

enum WrapperType { sliver, normal }

class ElevatedFlexContainer extends StatelessWidget {
  final List<Widget> children;
  final FlexDirection direction;
  final WrapperType wrapperType;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double elevation;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool enableScroll;
  final BorderRadius? borderRadius;
  final double? spacing;
  final void Function()? onTap;

  const ElevatedFlexContainer({
    super.key,
    required this.children,
    this.direction = FlexDirection.vertical,
    this.wrapperType = WrapperType.normal,
    this.margin,
    this.padding,
    this.color,
    this.elevation = 4.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.enableScroll = false,
    this.borderRadius,
    this.spacing,
    this.onTap,
  });

  const ElevatedFlexContainer.horizontal({
    super.key,
    required this.children,
    this.wrapperType = WrapperType.normal,
    this.margin,
    this.padding,
    this.color,
    this.elevation = 4.0,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.borderRadius,
    this.spacing,
    this.onTap,
  }) : direction = FlexDirection.horizontal,
       enableScroll = false;

  const ElevatedFlexContainer.vertical({
    super.key,
    required this.children,
    this.wrapperType = WrapperType.normal,
    this.margin,
    this.padding,
    this.color,
    this.elevation = 4.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.enableScroll = true,
    this.borderRadius,
    this.spacing,
    this.onTap,
  }) : direction = FlexDirection.vertical;

  const ElevatedFlexContainer.sliverHorizontal({
    super.key,
    required this.children,
    this.margin,
    this.padding,
    this.color,
    this.elevation = 2.0,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.borderRadius,
    this.spacing,
    this.onTap,
  }) : direction = FlexDirection.horizontal,
       wrapperType = WrapperType.sliver,
       mainAxisSize = MainAxisSize.max,
       enableScroll = false;

  const ElevatedFlexContainer.sliverVertical({
    super.key,
    required this.children,
    this.margin,
    this.padding,
    this.color,
    this.elevation = 2.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.enableScroll = true,
    this.borderRadius,
    this.spacing,
    this.onTap,
  }) : direction = FlexDirection.vertical,
       wrapperType = WrapperType.sliver,
       mainAxisSize = MainAxisSize.min;

  EdgeInsetsGeometry get _defaultMargin {
    if (wrapperType == WrapperType.sliver) {
      return EdgeInsets.zero;
    }
    return const EdgeInsets.all(16.0);
  }

  EdgeInsetsGeometry get _defaultPadding {
    if (direction == FlexDirection.horizontal &&
        wrapperType == WrapperType.sliver) {
      return EdgeInsets.zero;
    }
    return const EdgeInsets.all(16.0);
  }

  /// Construye la lista de hijos con espaciado si se especifica
  List<Widget> get _spacedChildren {
    if (spacing == null || spacing! <= 0) {
      return children;
    }

    final List<Widget> spacedList = [];
    for (int i = 0; i < children.length; i++) {
      spacedList.add(children[i]);
      if (i < children.length - 1) {
        if (direction == FlexDirection.horizontal) {
          spacedList.add(SizedBox(width: spacing));
        } else {
          spacedList.add(SizedBox(height: spacing));
        }
      }
    }
    return spacedList;
  }

  /// Construye el widget flex (Row o Column)
  Widget _buildFlexWidget() {
    final spacedChildren = _spacedChildren;

    if (direction == FlexDirection.horizontal) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: spacedChildren,
      );
    } else {
      Widget columnWidget = Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: spacedChildren,
      );

      if (enableScroll) {
        return SingleChildScrollView(child: columnWidget);
      }

      return columnWidget;
    }
  }

  /// Construye el contenedor Material
  Widget _buildMaterialContainer(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: elevation,
        color: color ?? Palette(context).surface,
        borderRadius: borderRadius,
        child: Container(
          padding: padding ?? _defaultPadding,
          child: _buildFlexWidget(),
        ),
      ),
    );
  }

  /// Construye el widget completo según el tipo de wrapper
  Widget _buildContent(BuildContext context) {
    final materialContainer = _buildMaterialContainer(context);

    if (wrapperType == WrapperType.sliver) {
      return SliverToBoxAdapter(
        child: Container(
          margin: margin ?? _defaultMargin,
          child: materialContainer,
        ),
      );
    } else {
      return Container(
        margin: margin ?? _defaultMargin,
        child: materialContainer,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}

// Extensión para facilitar el uso con tu Palette existente
extension ElevatedFlexContainerExtension on ElevatedFlexContainer {
  /// Método helper para usar con Palette personalizada
  static Widget withPalette(
    BuildContext context, {
    required List<Widget> children,
    FlexDirection direction = FlexDirection.vertical,
    WrapperType wrapperType = WrapperType.normal,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double elevation = 4.0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    bool enableScroll = false,
    BorderRadius? borderRadius,
    double? spacing,
    Color? customColor,
  }) {
    // Aquí puedes usar tu Palette(context).surface
    final color = customColor; // ?? Palette(context).surface;

    return ElevatedFlexContainer(
      direction: direction,
      wrapperType: wrapperType,
      margin: margin,
      padding: padding,
      color: color,
      elevation: elevation,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      enableScroll: enableScroll,
      borderRadius: borderRadius,
      spacing: spacing,
      children: children,
    );
  }
}
