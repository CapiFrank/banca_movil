import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/base_card.dart';
import 'package:banca_movil/views/components/square_avatar.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class TransferSelectDestinationMethod extends StatefulWidget {
  const TransferSelectDestinationMethod({super.key});

  @override
  State<TransferSelectDestinationMethod> createState() =>
      _TransferSelectDestinationMethodState();
}

class _TransferSelectDestinationMethodState
    extends State<TransferSelectDestinationMethod> {
  @override
  Widget build(BuildContext context) {
    return ScrollLayout.parent(
      title: 'Enviar dinero',
      children: [
        _buildSectionCard(
          Clarity.bank_solid,
          'Entre cuentas',
          'Envía dinero a otras cuentas del mismo banco',
          () => context.push(
            '/transfer/selectsourceaccount',
            extra: DestinationMethod.same,
          ),
        ),
        _buildSectionCard(
          Clarity.bank_solid,
          'Otros bancos (SINPE)',
          'Envía dinero a otras cuentas bancarias',
          () => context.push(
            '/transfer/selectsourceaccount',
            extra: DestinationMethod.sinpe,
          ),
        ),
        _buildSectionCard(
          Clarity.phone_handset_line,
          'SINPE Móvil',
          'Envía dinero a través de un número de teléfono',
          () => context.push(
            '/transfer/selectsourceaccount',
            extra: DestinationMethod.sinpeMovil,
          ),
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildSectionCard(
    IconData icon,
    String title,
    String subtitle,
    Function() onTap, {
    FontWeight? fontWeight,
  }) {
    return SliverToBoxAdapter(
      child: BaseCard(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        leading: SquareAvatar(
          child: Icon(
            icon,
            fontWeight: fontWeight,
            color: Palette(context).primary,
          ),
        ),
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Palette(context).onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: Icon(
          AntDesign.right_outline,
          size: 16,
          fontWeight: FontWeight.bold,
          color: Palette(context).onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

enum DestinationMethod { sinpe, sinpeMovil, same }
