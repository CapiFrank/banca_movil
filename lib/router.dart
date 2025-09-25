import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/account_partials.dart/account_details.dart';
import 'package:banca_movil/views/account_view.dart';
import 'package:banca_movil/views/deposit_view.dart';
import 'package:banca_movil/views/exchange_view.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/bottom_navbar.dart';
import 'package:banca_movil/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/account',
  routes: [
    GoRoute(path: '/', builder: (context, state) => LoginView()),
    GoRoute(path: '/exchange', builder: (context, state) => ExchangeView()),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        final location = state.fullPath ?? '';
        int currentIndex = 0;

        if (location == '/account') {
          currentIndex = 0;
        } else if (location == '/deposit') {
          currentIndex = 2;
        }
        final showBottomNav = [
          '/account',
          '/deposit',
        ].any((value) => location == value);
        return ScaffoldWithBottomNav(
          body: child,
          bottomNavigationBar: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation =
                  Tween<Offset>(
                    begin: const Offset(0, 1), // empieza desplazado hacia abajo
                    end: Offset.zero, // vuelve a su posición normal
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  );

              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: showBottomNav
                ? BottomNavBar(
                    key: ValueKey('withNav'),
                    index: currentIndex,
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
      routes: [
        GoRoute(path: '/account', builder: (context, state) => AccountView()),
        GoRoute(path: '/deposit', builder: (context, state) => DepositView()),
        GoRoute(
          path: '/account/details',
          builder: (context, state) {
            final account = state.extra as Account;
            return AccountDetails(account: account);
          },
        ),
      ],
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
        opacity: ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation,
        child: bottomNavigationBar,
      ),
    );
  }
}
