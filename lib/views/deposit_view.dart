import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/views/partials/account_partials.dart/account_card.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
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
      title: "Depositar",
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
                context.push('/deposit/firststep', extra: account);
              },
            );
          }, childCount: accounts.length),
        ),
      ],
    );
  }
}
