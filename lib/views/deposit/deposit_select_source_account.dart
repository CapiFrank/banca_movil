import 'package:banca_movil/bloc/auth/auth_bloc.dart';
import 'package:banca_movil/bloc/favorite_account/favorite_account_bloc.dart';
import 'package:banca_movil/bloc/payment/payment_bloc.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/utils/styles.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/utils/use_state.dart';
import 'package:banca_movil/views/components/layouts/empty_state_handler.dart';
import 'package:banca_movil/views/components/primitives/base_card.dart';
import 'package:banca_movil/views/components/primitives/input_text.dart';
import 'package:banca_movil/views/components/composites/primary_button.dart';
import 'package:banca_movil/views/components/primitives/loading_progress.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/deposit/deposit_payment_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class DepositSelectSourceAccount extends StatefulWidget {
  final Account destinationAccount;

  const DepositSelectSourceAccount({
    super.key,
    required this.destinationAccount,
  });

  @override
  State<DepositSelectSourceAccount> createState() =>
      _DepositSelectSourceAccountState();
}

class _DepositSelectSourceAccountState extends State<DepositSelectSourceAccount>
    with UseStateMixin {
  late final TextEditingController _accountNameController;
  late final TextEditingController _accountNumberController;

  late UseState<bool> _isAddingFavorite;

  bool get _isAccountInputValid {
    return _accountNameController.text.isNotEmpty &&
        (_accountNumberController.text.length == 22 &&
            _accountNumberController.text.startsWith('CR'));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthBloc>().user!;
      context.read<FavoriteAccountBloc>().add(
        FavoriteAccountsRequested(user: user, type: PaymentMethod.deposit),
      );
    });
    _accountNameController = TextEditingController();
    _accountNumberController = TextEditingController(text: 'CR');
    _isAddingFavorite = useState<bool>(false);

    _accountNameController.addListener(_refresh);
    _accountNumberController.addListener(_refresh);
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _navigateToPaymentInfo(FavoriteAccount account) {
    context.push(
      '/deposit/paymentinfo',
      extra: DepositPaymentInfoParams(
        sourceAccount: account,
        destinationAccount: widget.destinationAccount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteAccountBloc, FavoriteAccountState>(
      listener: (context, state) {
        if (state is FavoriteAccountError) {
          SweetAlert.show(
            type: SweetAlertType.error,
            message: state.message,
            context: context,
            autoClose: Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) => LoadingProgress(
        isLoaded: state is! FavoriteAccountLoaded,
        builder: () {
          if (state is FavoriteAccountLoaded) {
            final favoriteAccounts = state.favoriteAccounts;

            return BaseScaffold(
              body: ScrollLayout.child(
                title: "Traer dinero",
                children: [
                  _buildSectionTitle("Cuenta de destino"),
                  SliverToBoxAdapter(
                    child: AccountCard(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      account: widget.destinationAccount,
                      showTrailingIcon: false,
                    ),
                  ),
                  _buildSectionTitle("Cuenta de origen"),
                  _isAddingFavorite.value
                      ? _buildFavoriteForm()
                      : _buildFavoriteAccountsList(favoriteAccounts),
                ],
              ),
              bottomNavigationBar: _buildBottomAction(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBottomAction() {
    final user = context.read<AuthBloc>().user!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: PrimaryButton(
          labelText: _isAddingFavorite.value ? 'Continuar' : 'Nueva cuenta',
          isEnabled: !_isAddingFavorite.value || _isAccountInputValid,
          onPressed: () {
            if (!_isAddingFavorite.value) {
              _isAddingFavorite.setValue(!_isAddingFavorite.value);
            } else {
              final newAccount = FavoriteAccount(
                alias: _accountNameController.text,
                accountNumber: _accountNumberController.text,
                type: PaymentMethod.deposit,
                userId: user.id!,
              );
              context.read<PaymentBloc>().add(SetSaveFavoriteRequested(true));
              _navigateToPaymentInfo(newAccount);
            }
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(title, style: sectionTitleStyle),
      ),
    );
  }

  Widget _buildFavoriteAccountsList(List<FavoriteAccount> favoriteAccounts) {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: EmptyStateHandler(
        isEmpty: favoriteAccounts.isEmpty,
        emptyMessage: 'No hay cuentas favoritas',
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: favoriteAccounts.length,
          itemBuilder: (context, index) {
            final account = favoriteAccounts[index];
            return BaseCard(
              onTap: () => _navigateToPaymentInfo(account),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              leading: SquareAvatar(
                child: Icon(
                  Clarity.bank_solid,
                  color: Palette(context).primary,
                  size: 24,
                ),
              ),
              title: Text(
                account.alias,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(account.accountNumber),
              trailing: _buildFavoriteDeleteButton(account),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteDeleteButton(FavoriteAccount account) {
    return SquareAvatar(
      size: 24,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Clarity.favorite_solid,
          color: Palette(context).primary,
          size: 14,
        ),
        onPressed: () async {
          SweetAlert.show(
            context: context,
            type: SweetAlertType.confirm,
            title: 'Borrar favorito',
            message:
                '¿Está seguro de que desea borrar esta cuenta de favoritos?',
            labelConfirm: 'Sí, borrar de favorito',
            labelCancel: 'No, mantener',
            onConfirm: () {
              context.read<FavoriteAccountBloc>().add(
                FavoriteAccountDeleted(favoriteAccount: account),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoriteForm() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            InputText(
              labelText: 'Alias de la cuenta',
              textEditingController: _accountNameController,
            ),
            const SizedBox(height: 8),
            InputText(
              textEditingController: _accountNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                PrefixInputFormatter(prefix: 'CR'),
                LengthLimitingTextInputFormatter(22),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
