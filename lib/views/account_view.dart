import 'package:banca_movil/views/account_partials.dart/account_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/icon_text.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final List<Account> accounts = [
    Account(
      type: "Cuenta de Ahorros",
      number: "123-456-789",
      owner: "Juan Pérez",
      balance: "₡1,250,000.00",
    ),
    Account(
      type: "Cuenta de Ahorros",
      number: "987-654-321",
      owner: "Adriana Gómez",
      balance: "₡2,750,000.00",
    ),
  ];

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
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final account = accounts[index];
            return AccountCard(
              account: account,
              onTap: () {
                context.push('/account/details', extra: account);
              },
            );
          }, childCount: accounts.length),
        ),
      ],
    );
  }
}
