import 'package:banca_movil/bloc/account/account_bloc.dart';
import 'package:banca_movil/bloc/auth/auth_bloc.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/primitives/loading_progress.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DepositSelectDestinationAccount extends StatefulWidget {
  const DepositSelectDestinationAccount({super.key});

  @override
  State<DepositSelectDestinationAccount> createState() =>
      _DepositSelectDestinationAccountState();
}

class _DepositSelectDestinationAccountState
    extends State<DepositSelectDestinationAccount> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthBloc>().user!;
      context.read<AccountBloc>().add(AccountsRequested(user: user));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountError) {
          SweetAlert.show(
            context: context,
            type: SweetAlertType.error,
            message: state.message,
            autoClose: const Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) => LoadingProgress(
        isLoaded: state is! AccountLoaded,
        builder: () {
          if (state is AccountLoaded) {
            final accounts = state.accounts;

            return ScrollLayout.parent(
              isEmpty: accounts.isEmpty,
              emptyMessage: "No hay cuentas disponibles.",
              title: "Traer dinero",
              children: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'Seleccione la cuenta de destino',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final account = accounts[index];
                    return AccountCard(
                      account: account,
                      onTap: () {
                        context.push(
                          '/deposit/selectsourceaccount',
                          extra: account,
                        );
                      },
                    );
                  }, childCount: accounts.length),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
