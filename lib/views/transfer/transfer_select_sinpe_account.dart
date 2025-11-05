import 'package:banca_movil/bloc/auth/auth_bloc.dart';
import 'package:banca_movil/bloc/favorite_account/favorite_account_bloc.dart';
import 'package:banca_movil/bloc/interbank_account/interbank_account_bloc.dart';
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
import 'package:banca_movil/views/components/composites/primary_checkbox.dart';
import 'package:banca_movil/views/components/primitives/loading_progress.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/transfer/transfer_payment_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class TransferSelectSinpeAccount extends StatefulWidget {
  final Account sourceAccount;
  const TransferSelectSinpeAccount({super.key, required this.sourceAccount});

  @override
  State<TransferSelectSinpeAccount> createState() =>
      _TransferSelectSinpeAccountState();
}

class _TransferSelectSinpeAccountState extends State<TransferSelectSinpeAccount>
    with UseStateMixin {
  late TextEditingController _accountNumberController;

  late UseState<bool> _isAddingFavorite;

  bool get _isAccountNumberValid {
    return _accountNumberController.text.startsWith('CR') &&
        _accountNumberController.text.length == 22;
  }

  static const _sectionPadding = EdgeInsets.fromLTRB(16, 8, 16, 4);
  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  void _navigateToPaymentInfo(FavoriteAccount account) {
    context.push(
      '/transfer/paymentinfo',
      extra: TransferPaymentInfoParams(
        sourceAccount: widget.sourceAccount,
        destinationAccount: account,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthBloc>().user!;
      context.read<FavoriteAccountBloc>().add(
        FavoriteAccountsRequested(user: user, type: PaymentMethod.sinpe),
      );
    });
    _accountNumberController = TextEditingController(text: 'CR');
    _isAddingFavorite = useState<bool>(false);
    _accountNumberController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavoriteAccountBloc, FavoriteAccountState>(
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
        ),
        BlocListener<InterbankAccountBloc, InterbankAccountState>(
          listener: (context, state) {
            if (state is InterbankAccountError) {
              SweetAlert.show(
                type: SweetAlertType.error,
                message: state.message,
                context: context,
                autoClose: Duration(seconds: 2),
              );
            } else if (state is InterbankAccountSearchSuccess) {
              final user = context.read<AuthBloc>().user!;
              final account = FavoriteAccount(
                alias: state.interbankAccount.name,
                accountNumber: state.interbankAccount.ibanNumber,
                userId: user.id!,
              );
              _navigateToPaymentInfo(account);
            }
          },
        ),
      ],
      child: BlocBuilder<FavoriteAccountBloc, FavoriteAccountState>(
        builder: (context, state) => LoadingProgress(
          isLoaded: state is! FavoriteAccountLoaded,
          builder: () {
            if (state is FavoriteAccountLoaded) {
              return BaseScaffold(
                body: ScrollLayout.child(
                  title: 'Enviar dinero',
                  children: [
                    _buildSectionTitle('Cuenta de origen'),
                    SliverToBoxAdapter(
                      child: AccountCard(
                        margin: _horizontalPadding,
                        account: widget.sourceAccount,
                        showTrailingIcon: false,
                      ),
                    ),
                    _buildSectionTitle('Cuenta de destino'),
                    if (_isAddingFavorite.value) ...[
                      _buildFavoriteForm(),
                      _buildAddToFavoritesCheckbox(),
                    ] else
                      _buildFavoriteAccountsList(state.favoriteAccounts),
                  ],
                ),
                bottomNavigationBar: _buildBottomAction(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
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

  Widget _buildFavoriteForm() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: _horizontalPadding,
        child: Column(
          children: [
            InputText(
              textEditingController: _accountNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PrefixInputFormatter(prefix: 'CR'),
                LengthLimitingTextInputFormatter(22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToFavoritesCheckbox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocSelector<PaymentBloc, PaymentState, bool>(
          selector: (state) => state.saveAsFavorite,
          builder: (_, isChecked) {
            return PrimaryCheckbox(
              labelText: 'Agregar a favoritos',
              value: isChecked,
              onChanged: (v) =>
                  context.read<PaymentBloc>().add(SetSaveFavoriteRequested(v)),
            );
          },
        ),
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
              onTap: () {
                _navigateToPaymentInfo(account);
              },
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              trailing: _buildRemoveFavoriteButton(account),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRemoveFavoriteButton(FavoriteAccount account) {
    return SquareAvatar(
      size: 24,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Clarity.favorite_solid,
          color: Palette(context).primary,
          size: 14,
        ),
        onPressed: () {
          SweetAlert.show(
            context: context,
            type: SweetAlertType.confirm,
            title: 'Borrar favorito',
            message:
                '¿Está seguro de que desea borrar esta cuenta de favoritos?',
            labelConfirm: 'Sí, borrar de favorito',
            onConfirm: () {
              context.read<FavoriteAccountBloc>().add(
                FavoriteAccountDeleted(favoriteAccount: account),
              );
            },
            labelCancel: 'No, mantener',
          );
        },
      ),
    );
  }

  Widget _buildBottomAction() {
    final bloc = context.read<InterbankAccountBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: PrimaryButton(
          labelText: _isAddingFavorite.value ? 'Continuar' : 'Nueva cuenta',
          isEnabled: !_isAddingFavorite.value || _isAccountNumberValid,
          onPressed: () {
            if (!_isAddingFavorite.value) {
              _isAddingFavorite.setValue(true);
              return;
            }
            bloc.add(
              SearchInterbankAccountRequested(_accountNumberController.text),
            );
          },
        ),
      ),
    );
  }
}
