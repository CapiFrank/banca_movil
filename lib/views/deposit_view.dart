import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/icon_text.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  Widget _buildHeader(BuildContext context) {
    return Text(
      'BMóvil',
      style: TextStyle(
        color: Palette(context).surface,
        fontSize: 26,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScrollLayout(
      automaticallyImplyLeading: false,
      toolbarHeight: 50,
      backgroundColor: Palette(context).primary,
      headerChild: _buildHeader(context),
      actions: [
        IconText(
          position: IconPosition.right,
          icon: Icon(
            MingCute.exit_line,
            size: 28,
            color: Palette(context).onPrimary,
          ),
          label: Text(
            "Salir",
            style: TextStyle(
              color: Palette(context).onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () => context.push('/'),
        ),
      ],
      children: [

      ],
    );
  }
}
