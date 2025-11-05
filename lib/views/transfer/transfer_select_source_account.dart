import 'package:banca_movil/bloc/account/account_bloc.dart';
import 'package:banca_movil/bloc/auth/auth_bloc.dart';
import 'package:banca_movil/bloc/payment/payment_bloc.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/primitives/loading_progress.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransferSelectSourceAccount extends StatefulWidget {
  const TransferSelectSourceAccount({super.key});

  @override
  State<TransferSelectSourceAccount> createState() =>
      _TransferSelectSourceAccountState();
}

class _TransferSelectSourceAccountState
    extends State<TransferSelectSourceAccount> {
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
            return ScrollLayout.child(
              isEmpty: accounts.isEmpty,
              emptyMessage: "No hay cuentas disponibles.",
              title: 'Enviar dinero',
              children: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'Seleccione la cuenta de origen',
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
                        final type = context.read<PaymentBloc>().paymentMethod;
                        final route = switch (type) {
                          PaymentMethod.sameBank =>
                            '/transfer/selectdestinationaccount',
                          PaymentMethod.sinpe => '/transfer/selectsinpeaccount',
                          PaymentMethod.sinpeMovil =>
                            '/transfer/selectsinpemobileaccount',
                          PaymentMethod.deposit => '',
                        };

                        context.push(route, extra: account);
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
