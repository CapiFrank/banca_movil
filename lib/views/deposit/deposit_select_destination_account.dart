import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/views/components/account_card.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DepositSelectDestinationAccount extends StatefulWidget {
  const DepositSelectDestinationAccount({super.key});

  @override
  State<DepositSelectDestinationAccount> createState() =>
      _DepositSelectDestinationAccountState();
}

class _DepositSelectDestinationAccountState
    extends State<DepositSelectDestinationAccount> {
  final List<Account> accounts = [
    Account(
      type: "Cuenta de Ahorros",
      number: "CR050000000000123456789", // IBAN generado
      owner: "Juan Pérez",
      balance: "₡1,250,000.00",
    ),
    Account(
      type: "Cuenta de Ahorros",
      number: "CR050000000000987654321", // IBAN generado
      owner: "Adriana Gómez",
      balance: "₡2,750,000.00",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollLayout.parent(
      title: "Traer dinero",
      children: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Seleccione la cuenta de destino',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final account = accounts[index];
            return AccountCard(
              account: account,
              onTap: () {
                context.push('/deposit/selectsourceaccount', extra: account);
              },
            );
          }, childCount: accounts.length),
        ),
      ],
    );
  }
}
