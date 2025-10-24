import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Center(child: SingleChildScrollView(child: child)),
    );
  }
}
