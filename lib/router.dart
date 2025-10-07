import 'package:banca_movil/views/partials/deposit_partials.dart/deposit_first_step.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/partials/account_partials.dart/account_details.dart';
import 'package:banca_movil/views/account_view.dart';
import 'package:banca_movil/views/deposit_view.dart';
import 'package:banca_movil/views/exchange_view.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/bottom_navbar.dart';
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
    path: '/deposit',
    builder: (_, __) => const DepositView(),
    showBottomNav: true,
    navIndex: 2,
  ),
  AppRoute(
    path: '/account/details',
    builder: (_, state) {
      final account = state.extra as Account;
      return AccountDetails(account: account);
    },
  ),
  AppRoute(
    path: '/deposit/firststep',
    builder: (_, state) {
      final account = state.extra as Account;
      return DepositFirstStep(account: account);
    },
  ),
];
final router = GoRouter(
  initialLocation: '/account',
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
                        case 2:
                          context.go('/deposit');
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
      body: body,
      bottomNavigationBar: FadeTransition(
        opacity:
            ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation,
        child: bottomNavigationBar,
      ),
    );
  }
}
