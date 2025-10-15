import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class ScrollLayout extends StatelessWidget {
  final Widget? headerChild;
  final List<Widget>? children;
  final Widget? child;
  final double toolbarHeight;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;
  final bool isEmpty;
  final bool showEmptyMessage;
  final bool forceElevated;
  final double? elevation;
  final String emptyMessage;
  final List<Widget>? actions;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final String? title;
  final String? path;

  const ScrollLayout({
    super.key,
    this.headerChild,
    this.automaticallyImplyLeading = false,
    this.actions,
    this.children,
    this.child,
    this.toolbarHeight = 300,
    this.backgroundColor,
    this.isEmpty = false,
    this.showEmptyMessage = true,
    this.emptyMessage = "No hay datos disponibles.",
    this.forceElevated = false,
    this.elevation,
    this.controller,
    this.physics,
    this.title,
    this.path,
  }) : assert(
         !(children != null && child != null),
         'No puedes usar "child" y "children" al mismo tiempo',
       );
  factory ScrollLayout.parent({
    Key? key,
    bool automaticallyImplyLeading = false,
    List<Widget>? children,
    Widget? child,
    Color? backgroundColor,
    double toolbarHeight = 50,
    bool isEmpty = false,
    bool showEmptyMessage = true,
    String emptyMessage = "No hay datos disponibles.",
    bool forceElevated = false,
    double? elevation,
    ScrollController? controller,
    ScrollPhysics? physics,
    String title = 'BMóvil',
    String path = '/',
  }) {
    return ScrollLayout(
      key: key,
      automaticallyImplyLeading: automaticallyImplyLeading,
      children: children,
      child: child,
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      isEmpty: isEmpty,
      showEmptyMessage: showEmptyMessage,
      emptyMessage: emptyMessage,
      forceElevated: forceElevated,
      elevation: elevation,
      controller: controller,
      physics: physics,
      headerChild: _Header(title: title),
      actions: [_ExitButton(path: path)],
    );
  }

  factory ScrollLayout.child({
    Key? key,
    bool automaticallyImplyLeading = true,
    List<Widget>? children,
    Widget? child,
    Color? backgroundColor,
    double toolbarHeight = 50,
    bool isEmpty = false,
    bool showEmptyMessage = true,
    String emptyMessage = "No hay datos disponibles.",
    bool forceElevated = false,
    double? elevation,
    ScrollController? controller,
    String title = 'BMóvil',
    ScrollPhysics? physics,
  }) {
    return ScrollLayout(
      key: key,
      automaticallyImplyLeading: automaticallyImplyLeading,
      children: children,
      child: child,
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      isEmpty: isEmpty,
      showEmptyMessage: showEmptyMessage,
      emptyMessage: emptyMessage,
      forceElevated: forceElevated,
      elevation: elevation,
      controller: controller,
      physics: physics ?? NeverScrollableScrollPhysics(),
      headerChild: _Header(title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> effectiveChildren;
    if (child != null) {
      effectiveChildren = [child!];
    } else {
      effectiveChildren = children ?? [];
    }
    return CustomScrollView(
      physics: physics,
      controller: controller,
      slivers: [
        SliverAppBar(
          iconTheme: IconThemeData(color: Palette(context).primaryText),
          leading: automaticallyImplyLeading
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(BoxIcons.bx_chevron_left, size: 38),
                )
              : null,
          automaticallyImplyLeading: automaticallyImplyLeading,
          pinned: true,
          forceElevated: forceElevated,
          elevation: elevation,
          toolbarHeight: toolbarHeight,
          backgroundColor: backgroundColor ?? Palette(context).primary,
          shadowColor: Palette(context).shadow,
          centerTitle: true,
          title: headerChild,
          actions: actions ?? <Widget>[Container()],
        ),
        if (isEmpty && showEmptyMessage)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette(context).onBackground.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          )
        else
          ...effectiveChildren,
      ],
    );
  }
}

class _ExitButton extends StatelessWidget {
  final String path;
  const _ExitButton({required this.path});

  @override
  Widget build(BuildContext context) {
    return IconText(
      position: IconPosition.right,
      icon: Icon(
        MingCute.exit_line,
        size: 28,
        color: Palette(context).primaryText,
      ),
      label: Text(
        "Salir",
        style: TextStyle(
          color: Palette(context).primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () => context.push(path),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Palette(context).primaryText,
        fontSize: 26,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
