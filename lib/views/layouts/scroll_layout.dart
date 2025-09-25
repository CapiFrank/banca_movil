import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ScrollLayout extends StatelessWidget {
  final Widget? headerChild;
  final List<Widget> children;
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

  const ScrollLayout({
    super.key,
    this.headerChild,
    this.automaticallyImplyLeading = false,
    this.actions,
    required this.children,
    this.toolbarHeight = 300,
    this.backgroundColor,
    this.isEmpty = false,
    this.showEmptyMessage = true,
    this.emptyMessage = "No hay datos disponibles.",
    this.forceElevated = false,
    this.elevation,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: physics,
      controller: controller,
      slivers: [
        SliverAppBar(
          iconTheme: IconThemeData(color: Palette(context).onPrimary),
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
          shadowColor: Colors.black,
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
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          ...children,
      ],
    );
  }
}
