import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/transfer/transfer_select_destination_method.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransferSelectSourceAccount extends StatefulWidget {
  final DestinationMethod type;
  const TransferSelectSourceAccount({super.key, required this.type});

  @override
  State<TransferSelectSourceAccount> createState() =>
      _TransferSelectSourceAccountState();
}

class _TransferSelectSourceAccountState
    extends State<TransferSelectSourceAccount> {
  @override
  Widget build(BuildContext context) {
    return ScrollLayout.child(
      title: 'Enviar dinero',
      children: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Seleccione la cuenta de origen',
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
                final route = switch (widget.type) {
                  DestinationMethod.same =>
                    '/transfer/selectdestinationaccount',
                  DestinationMethod.sinpe => '/transfer/selectsinpeaccount',
                  DestinationMethod.sinpeMovil =>
                    '/transfer/selectsinpemobileaccount',
                };

                context.push(route, extra: account);
              },
            );
          }, childCount: accounts.length),
        ),
      ],
    );
  }
}

final List<Account> accounts = [
];
