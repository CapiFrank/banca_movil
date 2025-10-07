import 'package:banca_movil/views/partials/account_partials.dart/account_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banca_movil/models/account.dart';
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

  @override
  Widget build(BuildContext context) {
    return ScrollLayout.parent(
      title: "Cuentas",
      child: SliverList(
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
    );
  }
}
