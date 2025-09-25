import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/account_partials.dart/account_card.dart';
import 'package:banca_movil/views/components/categorize_item.dart';
import 'package:banca_movil/views/components/selectable_tab_item.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class AccountDetails extends StatefulWidget {
  final Account account;
  const AccountDetails({super.key, required this.account});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  bool isOlder = false;
  bool isBlocked = false;

  setIsOlder(value) {
    setState(() {
      isOlder = value;
    });
  }

  setIsBlocked(value) {
    setState(() {
      isBlocked = value;
    });
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Text(
        'BMóvil',
        style: TextStyle(
          color: Palette(context).surface,
          fontSize: 26,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Palette(context).background,
      body: ScrollLayout(
        physics: NeverScrollableScrollPhysics(),
        automaticallyImplyLeading: true,
        toolbarHeight: 50,
        backgroundColor: Palette(context).primary,
        headerChild: _buildHeader(context),
        children: [
          SliverToBoxAdapter(
            child: AccountCard(
              account: widget.account,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: true,
            child: Material(
              elevation: 2,
              color: Palette(context).surface.withValues(alpha: 0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SelectableTabItem(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          isSelected: !isOlder,
                          onPressed: () {
                            setIsOlder(!isOlder);
                          },
                          primaryColor: Palette(context).primary,
                          child: Text(
                            'Recientes',
                            style: TextStyle(
                              fontSize: 20,
                              color: Palette(context).primary,
                            ),
                          ),
                        ),
                        SelectableTabItem(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          isSelected: isOlder,
                          onPressed: () {
                            setIsOlder(!isOlder);
                          },
                          primaryColor: Palette(context).primary,
                          child: Text(
                            'Anteriores',
                            style: TextStyle(
                              fontSize: 20,
                              color: Palette(context).primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategorizeItem(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          isSelected: !isBlocked,
                          onPressed: () {
                            setIsBlocked(!isBlocked);
                          },
                          primaryColor: Palette(context).primary,
                          child: Text(
                            'Aplicadas',
                            style: TextStyle(
                              fontSize: 18,
                              color: Palette(context).onPrimary,
                            ),
                          ),
                        ),
                        CategorizeItem(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          isSelected: isBlocked,
                          onPressed: () {
                            setIsBlocked(!isBlocked);
                          },
                          primaryColor: Palette(context).primary,
                          child: Text(
                            'Bloqueadas',
                            style: TextStyle(
                              fontSize: 18,
                              color: Palette(context).onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // La lista ya se adapta al espacio restante
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return TransactionItem(index: index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final int index;

  const TransactionItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        elevation: 2,
        color: Palette(context).surface,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          leading: _buildTransactionIcon(),
          title: Text(
            'Transacción ${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Palette(context).onSurface,
            ),
          ),
          subtitle: Text(
            'Descripción detallada de la transacción',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: _buildTransactionAmount(),
        ),
      ),
    );
  }

  Widget _buildTransactionIcon() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        index % 2 == 0 ? FontAwesome.money_bill_1 : FontAwesome.credit_card,
        color: index % 2 == 0 ? Colors.green : Colors.red,
        size: 18,
      ),
    );
  }

  Widget _buildTransactionAmount() {
    final amount = 50000 * (index + 1);
    final isPositive = index % 2 == 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${isPositive ? '+' : '-'}₡${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'Hoy ${index + 1}:00',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}
