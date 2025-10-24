import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  void initState() {
    met();
    super.initState();
  }

  late List<Account> accounts = [];
  void met() async {
    final acc = await Account().all();
    setState(() {
      accounts = acc;
    });
  }

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
