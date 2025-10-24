import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/utils/styles.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/utils/use_state.dart';
import 'package:banca_movil/views/components/composites/section_card.dart';
import 'package:banca_movil/views/components/primitives/input_text.dart';
import 'package:banca_movil/views/components/composites/primary_button.dart';
import 'package:banca_movil/views/components/composites/primary_checkbox.dart';
import 'package:banca_movil/views/components/primitives/selectable_tab.dart';
import 'package:banca_movil/views/components/primitives/selectable_tab_item.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/transfer/transfer_payment_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class TransferSelectDestinationAccount extends StatefulWidget {
  final Account sourceAccount;
  const TransferSelectDestinationAccount({
    super.key,
    required this.sourceAccount,
  });

  @override
  State<TransferSelectDestinationAccount> createState() =>
      _TransferSelectDestinationAccountState();
}

class _TransferSelectDestinationAccountState
    extends State<TransferSelectDestinationAccount>
    with UseStateMixin {
  late final TextEditingController _accountNumberController;

  late UseState<bool> _isFavoriteChecked;
  late UseState<bool> _isAddingFavorite;
  late UseState<bool> _isBankAccountSelected;

  // Constantes de estilo y padding reutilizables

  static const _sectionPadding = EdgeInsets.fromLTRB(16, 8, 16, 4);
  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  bool get _isAccountNumberValid {
    return _accountNumberController.text.length < 15 ||
        (_accountNumberController.text.startsWith('CR') &&
            _accountNumberController.text.length < 22);
  }

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
    _isFavoriteChecked = useState<bool>(false);
    _isBankAccountSelected = useState<bool>(true);
    _isAddingFavorite = useState<bool>(false);
    _accountNumberController = TextEditingController();

    _accountNumberController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: ScrollLayout.child(
        title: "Enviar dinero",
        children: [
          _buildSectionTitle("Cuenta de origen"),
          SliverToBoxAdapter(
            child: AccountCard(
              account: widget.sourceAccount,
              showTrailingIcon: false,
            ),
          ),
          _buildSectionTitle("Cuenta de destino"),
          if (_isAddingFavorite.value) ...[
            _buildAccountTypeSelector(),
            _buildFavoriteForm(),
            _buildAddToFavoritesCheckbox(),
          ] else
            _buildFavoriteAccountsList(),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  /// Widgets auxiliares

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: _sectionPadding,
        child: Text(title, style: sectionTitleStyle),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SelectableTab(
          children: [
            SelectableTabItem(
              isSelected: _isBankAccountSelected.value,
              onPressed: () => _toggleAccountType(true),
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.all(4),
              child: _buildTabLabel(
                'Cuenta cliente',
                _isBankAccountSelected.value,
              ),
            ),
            SelectableTabItem(
              isSelected: !_isBankAccountSelected.value,
              onPressed: () => _toggleAccountType(false),
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.all(4),
              child: _buildTabLabel('IBAN', !_isBankAccountSelected.value),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleAccountType(bool selectBankAccount) {
    _accountNumberController.text = selectBankAccount ? '' : 'CR';
    _isBankAccountSelected.setValue(selectBankAccount);
  }

  Text _buildTabLabel(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected
            ? Palette(context).shadow.withValues(alpha: 0.6)
            : Palette(context).shadow.withValues(alpha: 0.4),
        fontWeight: FontWeight.bold,
        fontSize: 16,
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
                if (!_isBankAccountSelected.value) ...[
                  PrefixInputFormatter(prefix: 'CR'),
                  LengthLimitingTextInputFormatter(22),
                ] else
                  LengthLimitingTextInputFormatter(15),
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
        child: PrimaryCheckbox(
          labelText: 'Agregar a favoritos',
          value: _isFavoriteChecked.value,
          onChanged: _isFavoriteChecked.setValue,
        ),
      ),
    );
  }

  Widget _buildFavoriteAccountsList() {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: favoriteAccounts.length,
        itemBuilder: (context, index) {
          final account = favoriteAccounts[index];
          return SectionCard(
            wrapperType: WrapperType.normal,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: account.fullName,
            subtitle: account.accountNumber,
            icon: Clarity.bank_solid,
            trailing: _buildRemoveFavoriteButton(),
            onTap: () => _navigateToPaymentInfo(account),
          );
        },
      ),
    );
  }

  Widget _buildRemoveFavoriteButton() {
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
            labelCancel: 'No, mantener',
          );
        },
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: PrimaryButton(
          labelText: _isAddingFavorite.value ? 'Continuar' : 'Nueva cuenta',
          isEnabled: !_isAddingFavorite.value || !_isAccountNumberValid,
          onPressed: () {
            if (!_isAddingFavorite.value) {
              _isAddingFavorite.setValue(true);
              return;
            }
            final account = FavoriteAccount(
              fullName: '',
              accountNumber: _accountNumberController.text,
            );
            _navigateToPaymentInfo(account);
          },
        ),
      ),
    );
  }
}

/// Datos de prueba
final List<FavoriteAccount> favoriteAccounts = [
  FavoriteAccount(
    id: '1',
    fullName: "Daria Balderstone",
    accountNumber: "CR67413786348514992857",
  ),
  FavoriteAccount(
    id: '2',
    fullName: "Fern Clendennen",
    accountNumber: "CR46165721210591915402",
  ),
  FavoriteAccount(
    id: '3',
    fullName: "Nataniel Brodhead",
    accountNumber: "CR05394086336969003874",
  ),
  FavoriteAccount(
    id: '4',
    fullName: "Joannes Skiplorne",
    accountNumber: "CR60808607697498807745",
  ),
  FavoriteAccount(
    id: '5',
    fullName: "Malva Gowdie",
    accountNumber: "CR32874465662511046847",
  ),
  FavoriteAccount(
    id: '6',
    fullName: "Sibelle Dene",
    accountNumber: "CR61844857057144371786",
  ),
  FavoriteAccount(
    id: '7',
    fullName: "Olivero Laidel",
    accountNumber: "CR21569020118680658501",
  ),
  FavoriteAccount(
    id: '8',
    fullName: "Papagena Urion",
    accountNumber: "CR32081956207818461250",
  ),
  FavoriteAccount(
    id: '9',
    fullName: "Emiline Wilkenson",
    accountNumber: "CR62693940376249715543",
  ),
  FavoriteAccount(
    id: '10',
    fullName: "Rhoda Loding",
    accountNumber: "CR61184495984187589674",
  ),
];
