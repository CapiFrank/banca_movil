import 'package:banca_movil/bloc/payment/payment_bloc.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/utils/utilities.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/utils/styles.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/base_card.dart';
import 'package:banca_movil/views/components/composites/primary_button.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class DepositReview extends StatefulWidget {
  final DepositReviewParams params;
  const DepositReview({super.key, required this.params});

  @override
  State<DepositReview> createState() => _DepositReviewState();
}

class _DepositReviewState extends State<DepositReview> {
  static const _sectionPadding = EdgeInsets.fromLTRB(16, 8, 16, 4);
  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  void _onConfirm(BuildContext context) async {
    final amount = parseLocalizedNumber(widget.params.amount);
    final description = widget.params.description;
    final destinationAccount = widget.params.destinationAccount;
    final favoriteAccount = widget.params.sourceAccount;

    context.read<PaymentBloc>().add(
      ConfirmPaymentRequested(
        amount: amount,
        favoriteAccount: favoriteAccount,
        account: destinationAccount,
        description: description,
        paymentMethod: PaymentMethod.deposit
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          SweetAlert.show(
            context: context,
            type: SweetAlertType.success,
            title: "Éxito",
            message: "Operación realizada correctamente",
            autoClose: const Duration(seconds: 2),
          );
          if (context.mounted) {
            context.go('/account');
          }
        } else if (state is PaymentError) {
          SweetAlert.show(
            context: context,
            type: SweetAlertType.error,
            message: state.message,
            autoClose: const Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) {
        return BaseScaffold(
          body: ScrollLayout.child(
            title: 'Confirmación',
            children: [
              _buildSectionTitle('Cuenta de destino'),
              SliverToBoxAdapter(
                child: AccountCard(
                  margin: _horizontalPadding,
                  account: widget.params.destinationAccount,
                  showTrailingIcon: false,
                ),
              ),
              _buildSectionTitle('Cuenta de origen'),
              _buildSectionCard(
                Clarity.bank_solid_alerted,
                widget.params.sourceAccount.alias,
                widget.params.sourceAccount.accountNumber,
              ),
              _buildSectionTitle('Detalles de la transacción'),
              _buildSectionCard(
                Iconsax.moneys_outline,
                '₡${widget.params.amount}',
                widget.params.description,
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomAction(context),
        );
      },
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

  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: PrimaryButton(
          labelText: 'Confirmar',
          onPressed: () => _onConfirm(context),
        ),
      ),
    );
  }
}

class DepositReviewParams {
  final Account destinationAccount;
  final FavoriteAccount sourceAccount;
  final String amount;
  final String description;

  DepositReviewParams({
    required this.destinationAccount,
    required this.sourceAccount,
    required this.amount,
    required this.description,
  });
}
