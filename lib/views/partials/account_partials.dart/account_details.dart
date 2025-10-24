import 'package:banca_movil/models/transfer.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/transaction.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/base_card.dart';
import 'package:banca_movil/views/components/primitives/categorize_item.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:banca_movil/views/components/composites/account_card.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';

/// Enum para los filtros
enum TransactionFilter { all, applied, blocked }

class AccountDetails extends StatefulWidget {
  final Account account;
  const AccountDetails({super.key, required this.account});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late List<TransactionGroup> groups = [];
  TransactionFilter _filter = TransactionFilter.all;

  Future<void> _loadTransactions() async {
    final accountId = widget.account.id;
    final relatedTransfers = await Transfer().where(
      (element) =>
          element.sourceAccountId == accountId ||
          element.destinationAccountId == accountId,
    );
    final accountTransactions = relatedTransfers
        .where((t) => t.transaction != null)
        .map((t) => t.transaction!)
        .toList();
    final now = DateTime.now();
    final recentTransactions = accountTransactions
        .where((t) => now.difference(t.createdAt).inHours < 24)
        .toList();
    final olderTransactions = accountTransactions
        .where((t) => now.difference(t.createdAt).inHours >= 24)
        .toList();
    setState(() {
      groups = [
        TransactionGroup(title: "Recientes", items: recentTransactions),
        TransactionGroup(title: "Anteriores", items: olderTransactions),
      ];
    });
  }

  @override
  void initState() {
    _loadTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollLayout.child(
      title: 'Movimientos',
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
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return TransactionGroupWidget(
                  group: group,
                  isRecentGroup: group.title == "Recientes",
                  filter: _filter,
                  onFilterChanged: (f) => setState(() => _filter = f),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget de grupo de transacciones
class TransactionGroupWidget extends StatelessWidget {
  final TransactionGroup group;
  final bool isRecentGroup;
  final TransactionFilter filter;
  final ValueChanged<TransactionFilter>? onFilterChanged;

  const TransactionGroupWidget({
    super.key,
    required this.group,
    this.isRecentGroup = false,
    this.filter = TransactionFilter.all,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filteredItems = isRecentGroup
        ? group.items.where((t) {
            switch (filter) {
              case TransactionFilter.applied:
                return t.status == TransactionStatus.applied;
              case TransactionFilter.blocked:
                return t.status == TransactionStatus.blocked;
              case TransactionFilter.all:
                return true;
            }
          }).toList()
        : group.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado y filtros
        if (group.items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    style: Palette(context).textTheme.titleMedium?.copyWith(
                      color: Palette(context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isRecentGroup)
                  Row(
                    children: [
                      _buildFilterItem(
                        context,
                        label: "Todas",
                        value: TransactionFilter.all,
                      ),
                      _buildFilterItem(
                        context,
                        label: "Aplicadas",
                        value: TransactionFilter.applied,
                      ),
                      _buildFilterItem(
                        context,
                        label: "Bloqueadas",
                        value: TransactionFilter.blocked,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        // Lista de transacciones filtradas
        ...filteredItems.map(
          (t) => TransactionItem(transaction: t, isRecent: isRecentGroup),
        ),
      ],
    );
  }

  Widget _buildFilterItem(
    BuildContext context, {
    required String label,
    required TransactionFilter value,
  }) {
    return CategorizeItem(
      isSelected: filter == value,
      onPressed: () => onFilterChanged?.call(value),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Palette(context).primary,
          fontWeight: filter == value ? FontWeight.bold : FontWeight.w400,
        ),
      ),
    );
  }
}

/// Item de transacción
class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final bool isRecent;
  const TransactionItem({
    super.key,
    required this.transaction,
    this.isRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.type == TransactionType.income;
    final displayCurrency = transaction.currency == 'CRC' ? '₡' : '\$';
    final displayAmount = transaction.type == TransactionType.expense
        ? '-$displayCurrency${transaction.amount.toStringAsFixed(2)}'
        : '+$displayCurrency${transaction.amount.toStringAsFixed(2)}';

    final color = isPositive
        ? const Color(0xFF39E079)
        : const Color(0xFFEA2831);
    final textTheme = Palette(context).textTheme;

    return BaseCard(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      leading: SquareAvatar(
        color: color.withValues(alpha: 0.1),
        child: Icon(
          isPositive ? FontAwesome.money_bill_1 : FontAwesome.credit_card,
          color: color,
          size: 18,
        ),
      ),
      title: Text(
        transaction.description,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Palette(context).onSurface,
        ),
      ),
      subtitle: isRecent
          ? Text(
              transaction.status == TransactionStatus.applied
                  ? "Aplicada"
                  : "Bloqueada",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: Palette(context).onBackground.withValues(alpha: 0.4),
              ),
            )
          : null,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayAmount,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            transaction.createdAt.toLocal().toString().split(' ')[0],
            style: textTheme.bodySmall?.copyWith(
              color: Palette(context).onSurface.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Modelo de grupo
class TransactionGroup {
  final String title;
  final List<Transaction> items;

  TransactionGroup({required this.title, required this.items});
}
