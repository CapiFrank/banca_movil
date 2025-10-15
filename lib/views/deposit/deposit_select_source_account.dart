import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/utils/decorations.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/utils/use_state.dart';
import 'package:banca_movil/views/components/base_card.dart';
import 'package:banca_movil/views/components/input_text.dart';
import 'package:banca_movil/views/components/primary_button.dart';
import 'package:banca_movil/views/components/square_avatar.dart';
import 'package:banca_movil/views/components/sweet_alert.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/account_card.dart';
import 'package:banca_movil/views/deposit/deposit_payment_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              : _buildFavoriteAccountsList(),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildBottomAction() {
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
                fullName: _accountNameController.text,
                accountNumber: _accountNumberController.text,
              );
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

  Widget _buildFavoriteAccountsList() {
    return SliverFillRemaining(
      hasScrollBody: true,
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
              account.fullName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(account.accountNumber),
            trailing: _buildFavoriteDeleteButton(account),
          );
        },
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
