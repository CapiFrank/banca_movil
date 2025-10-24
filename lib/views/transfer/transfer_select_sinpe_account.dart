import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/utils/styles.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/utils/use_state.dart';
import 'package:banca_movil/views/components/primitives/base_card.dart';
import 'package:banca_movil/views/components/primitives/input_text.dart';
import 'package:banca_movil/views/components/composites/primary_button.dart';
import 'package:banca_movil/views/components/composites/primary_checkbox.dart';
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
  late UseState<bool> _isFavoriteChecked;

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
    _accountNumberController = TextEditingController(text: 'CR');
    _isAddingFavorite = useState<bool>(false);
    _isFavoriteChecked = useState<bool>(false);
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
            _buildFavoriteAccountsList(),
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
              account.fullName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(account.accountNumber),
            trailing: _buildRemoveFavoriteButton(),
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
          isEnabled: !_isAddingFavorite.value || _isAccountNumberValid,
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
