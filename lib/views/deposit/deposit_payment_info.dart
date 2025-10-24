import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/utils/styles.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/base_card.dart';
import 'package:banca_movil/views/components/primitives/input_text.dart';
import 'package:banca_movil/views/components/composites/primary_button.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/deposit/deposit_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class DepositPaymentInfo extends StatefulWidget {
  final DepositPaymentInfoParams params;
  const DepositPaymentInfo({super.key, required this.params});

  @override
  State<DepositPaymentInfo> createState() => _DepositPaymentInfoState();
}

class _DepositPaymentInfoState extends State<DepositPaymentInfo> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  bool get _areDetailsFieldsEmpty {
    return _amountController.text.isEmpty || _descriptionController.text.isEmpty;
  }

  static const _sectionPadding = EdgeInsets.fromLTRB(16, 8, 16, 4);
  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();

    _amountController.addListener(_refresh);
    _descriptionController.addListener(_refresh);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: ScrollLayout.child(
        title: 'Traer dinero',
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
          SliverToBoxAdapter(
            child: BaseCard(
              margin: _horizontalPadding,
              leading: SquareAvatar(
                child: Icon(
                  Clarity.bank_solid,
                  color: Palette(context).primary,
                  size: 24,
                ),
              ),
              title: Text(
                widget.params.sourceAccount.fullName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(widget.params.sourceAccount.accountNumber),
            ),
          ),
          _buildSectionTitle('Detalles de la transacción'),
          _buildPaymentInfo(),
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

  Widget _buildPaymentInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: _horizontalPadding,
        child: Column(
          children: [
            InputText(
              labelText: 'Monto',
              prefixText: '₡',
              textEditingController: _amountController,
              textInputAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                NumberInputFormatter(),
              ],
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),

            SizedBox(height: 8),
            InputText(
              labelText: 'Concepto',
              textEditingController: _descriptionController,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: PrimaryButton(
          labelText: 'Continuar',
          isEnabled: !_areDetailsFieldsEmpty,
          onPressed: () {
            context.push(
              '/deposit/review',
              extra: DepositReviewParams(
                destinationAccount: widget.params.destinationAccount,
                sourceAccount: widget.params.sourceAccount,
                amount: _amountController.text,
                description: _descriptionController.text,
              ),
            );
          },
        ),
      ),
    );
  }
}

class DepositPaymentInfoParams {
  final Account destinationAccount;
  final FavoriteAccount sourceAccount;

  DepositPaymentInfoParams({
    required this.sourceAccount,
    required this.destinationAccount,
  });
}
