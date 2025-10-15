import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/utils/decorations.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/base_card.dart';
import 'package:banca_movil/views/components/primary_button.dart';
import 'package:banca_movil/views/components/square_avatar.dart';
import 'package:banca_movil/views/components/sweet_alert.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/account_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class TransferReview extends StatefulWidget {
  final TransferReviewParams params;
  const TransferReview({super.key, required this.params});

  @override
  State<TransferReview> createState() => _TransferReviewState();
}

class _TransferReviewState extends State<TransferReview> {
  static const _sectionPadding = EdgeInsets.fromLTRB(16, 8, 16, 4);
  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: ScrollLayout.child(
        title: 'Confirmación',
        children: [
          _buildSectionTitle('Cuenta de origen'),
          SliverToBoxAdapter(
            child: AccountCard(
              margin: _horizontalPadding,
              account: widget.params.sourceAccount,
              showTrailingIcon: false,
            ),
          ),
          _buildSectionTitle('Cuenta de destino'),
          _buildSectionCard(
            Clarity.bank_solid_alerted,
            widget.params.destinationAccount.fullName,
            widget.params.destinationAccount.accountNumber,
          ),
          _buildSectionTitle('Detalles de la transacción'),
          _buildSectionCard(
            Iconsax.moneys_outline,
            '₡${widget.params.amount}',
            widget.params.description,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: _sectionPadding,
        child: Text(title, style: sectionTitleStyle),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return SliverToBoxAdapter(
      child: BaseCard(
        margin: _horizontalPadding,
        leading: SquareAvatar(
          child: Icon(icon, color: Palette(context).primary, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: PrimaryButton(
          labelText: 'Confirmar',
          onPressed: () async {
            await SweetAlert.show(
              context: context,
              type: SweetAlertType.success,
              title: "Éxito",
              message: "Operación realizada correctamente",
              autoClose: const Duration(seconds: 2),
            );
            // Una vez cerrado, navega
            if (context.mounted) {
              context.go('/account');
            }
          },
        ),
      ),
    );
  }
}

class TransferReviewParams {
  final Account sourceAccount;
  final FavoriteAccount destinationAccount;
  final String amount;
  final String description;

  TransferReviewParams({
    required this.sourceAccount,
    required this.destinationAccount,
    required this.amount,
    required this.description,
  });
}
