import 'package:banca_movil/bloc/account/account_bloc.dart';
import 'package:banca_movil/bloc/auth/auth_bloc.dart';
import 'package:banca_movil/bloc/exchange_rate/exchange_rate_bloc.dart';
import 'package:banca_movil/bloc/favorite_account/favorite_account_bloc.dart';
import 'package:banca_movil/bloc/interbank_account/interbank_account_bloc.dart';
import 'package:banca_movil/bloc/payment/payment_bloc.dart';
import 'package:banca_movil/bloc/sinpe_movil/sinpe_movil_bloc.dart';
import 'package:banca_movil/controllers/account_controller.dart';
import 'package:banca_movil/controllers/auth_controller.dart';
import 'package:banca_movil/controllers/exchange_rate_controller.dart';
import 'package:banca_movil/controllers/favorite_account_controller.dart';
import 'package:banca_movil/controllers/interbank_account_controller.dart';
import 'package:banca_movil/controllers/payment_controller.dart';
import 'package:banca_movil/controllers/sinpe_movil_controller.dart';
import 'package:banca_movil/views/deposit/deposit_select_source_account.dart';
import 'package:banca_movil/views/deposit/deposit_payment_info.dart';
import 'package:banca_movil/views/deposit/deposit_review.dart';
import 'package:banca_movil/views/service/service_selection.dart';
import 'package:banca_movil/views/transfer/transfer_payment_info.dart';
import 'package:banca_movil/views/transfer/transfer_review.dart';
import 'package:banca_movil/views/transfer/transfer_select_sinpe_account.dart';
import 'package:banca_movil/views/transfer/transfer_select_sinpe_mobile_account.dart';
import 'package:banca_movil/views/transfer/transfer_select_source_account.dart';
import 'package:banca_movil/views/transfer/transfer_select_destination_account.dart';
import 'package:banca_movil/views/transfer/transfer_select_destination_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/partials/account_partials.dart/account_details.dart';
import 'package:banca_movil/views/account_view.dart';
import 'package:banca_movil/views/deposit/deposit_select_destination_account.dart';
import 'package:banca_movil/views/exchange_view.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/bottom_navbar.dart';
import 'package:banca_movil/views/login_view.dart';

/// --- AppRoute Metadata ---
class AppRoute {
  final String path;
  final Widget Function(BuildContext, GoRouterState) builder;
  final bool showBottomNav;
  final int? navIndex;

  const AppRoute({
    required this.path,
    required this.builder,
    this.showBottomNav = false,
    this.navIndex,
  });

  GoRoute toRoute() {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

final appRoutes = [
  AppRoute(path: '/', builder: (_, __) => const LoginView()),
  AppRoute(path: '/exchange', builder: (_, __) => const ExchangeView()),
  AppRoute(
    path: '/account',
    builder: (_, __) => const AccountView(),
    showBottomNav: true,
    navIndex: 0,
  ),
  AppRoute(
    path: '/transfer',
    builder: (_, __) => const TransferSelectDestinationMethod(),
    showBottomNav: true,
    navIndex: 1,
  ),
  AppRoute(
    path: '/transfer/selectsourceaccount',
    builder: (_, __) => TransferSelectSourceAccount(),
  ),
  AppRoute(
    path: '/transfer/selectdestinationaccount',
    builder: (_, state) {
      final account = state.extra as Account;
      return TransferSelectDestinationAccount(sourceAccount: account);
    },
  ),
  AppRoute(
    path: '/transfer/selectsinpeaccount',
    builder: (_, state) {
      final account = state.extra as Account;
      return TransferSelectSinpeAccount(sourceAccount: account);
    },
  ),
  AppRoute(
    path: '/transfer/selectsinpemobileaccount',
    builder: (_, state) {
      final account = state.extra as Account;
      return TransferSelectSinpeMobileAccount(sourceAccount: account);
    },
  ),
  AppRoute(
    path: '/transfer/paymentinfo',
    builder: (_, state) {
      final params = state.extra as TransferPaymentInfoParams;
      return TransferPaymentInfo(params: params);
    },
  ),
  AppRoute(
    path: '/transfer/review',
    builder: (_, state) {
      final params = state.extra as TransferReviewParams;
      return TransferReview(params: params);
    },
  ),
  AppRoute(
    path: '/account/details',
    builder: (_, state) {
      final account = state.extra as Account;
      return AccountDetails(account: account);
    },
  ),
  AppRoute(
    path: '/deposit',
    builder: (_, __) => const DepositSelectDestinationAccount(),
    showBottomNav: true,
    navIndex: 2,
  ),
  AppRoute(
    path: '/service',
    builder: (_, __) => const ServiceSelection(),
    showBottomNav: true,
    navIndex: 3,
  ),
  AppRoute(
    path: '/deposit/selectsourceaccount',
    builder: (_, state) {
      final account = state.extra as Account;
      return DepositSelectSourceAccount(destinationAccount: account);
    },
  ),
  AppRoute(
    path: '/deposit/paymentinfo',
    builder: (_, state) {
      final params = state.extra as DepositPaymentInfoParams;
      return DepositPaymentInfo(params: params);
    },
  ),
  AppRoute(
    path: '/deposit/review',
    builder: (_, state) {
      final params = state.extra as DepositReviewParams;
      return DepositReview(params: params);
    },
  ),
];
final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final route = appRoutes.firstWhere(
          (r) => r.path == state.fullPath,
          orElse: () => AppRoute(path: '/', builder: (_, __) => SizedBox()),
        );

        return ScaffoldWithBottomNav(
          body: child,
          bottomNavigationBar: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation =
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  );
              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: route.showBottomNav
                ? BottomNavBar(
                    key: ValueKey(route.path),
                    index: route.navIndex ?? 0,
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          context.go('/account');
                          break;
                        case 1:
                          context.go('/transfer');
                          break;
                        case 2:
                          context.go('/deposit');
                          break;
                        case 3:
                          context.go('/service');
                          break;
                      }
                    },
                  )
                : const SizedBox.shrink(key: ValueKey('noNav')),
          ),
        );
      },
      routes: [for (final r in appRoutes) r.toRoute()],
    ),
  ],
);

class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  const ScaffoldWithBottomNav({
    super.key,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Palette(context).background,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(AuthController())),
          BlocProvider(create: (_) => AccountBloc(AccountController())),
          BlocProvider(
            create: (_) => FavoriteAccountBloc(FavoriteAccountController()),
          ),
          BlocProvider(
            create: (_) => ExchangeRateBloc(ExchangeRateController()),
          ),
          BlocProvider(create: (_) => PaymentBloc(PaymentController())),
          BlocProvider(create: (_) => SinpeMovilBloc(SinpeMovilController())),
          BlocProvider(create: (_) => InterbankAccountBloc(InterbankAccountController())),
        ],
        child: body,
      ),
      bottomNavigationBar: FadeTransition(
        opacity: ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation,
        child: bottomNavigationBar,
      ),
    );
  }
}
