import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
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
