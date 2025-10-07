import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:banca_movil/views/partials/account_partials.dart/account_card.dart';
import 'package:flutter/material.dart';

class DepositFirstStep extends StatefulWidget {
  final Account account;
  const DepositFirstStep({super.key, required this.account});

  @override
  State<DepositFirstStep> createState() => _DepositFirstStepState();
}

class _DepositFirstStepState extends State<DepositFirstStep> {
  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    return ScrollLayout.child(
      title: "Depositar",
      children: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Cuenta de destino',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: AccountCard(account: widget.account, onTap: () {}),
        ),
      ],
    );
  }
}
