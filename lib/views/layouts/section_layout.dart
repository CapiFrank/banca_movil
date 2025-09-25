import 'package:banca_movil/views/components/section.dart';
import 'package:flutter/material.dart';

class SectionLayout extends StatelessWidget {
  final Section? header;
  final Section? body;
  final Section? footer;

  const SectionLayout({super.key, this.header, this.body, this.footer});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: header ?? const SizedBox()),
              SingleChildScrollView(child: body ?? const SizedBox()),
              Expanded(child: footer ?? const SizedBox()),
            ],
          ),
        ),
      ],
    );
  }
}
