import 'package:banca_movil/views/components/base_card.dart';
import 'package:banca_movil/views/components/square_avatar.dart';
import 'package:flutter/material.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:icons_plus/icons_plus.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;

  const AccountCard({super.key, required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Palette(context).textTheme;

    final cardContent = BaseCard(
      margin: const EdgeInsets.all(0),
      onTap: onTap,
      leading: SquareAvatar(
        child: Icon(Clarity.bank_solid, color: Palette(context).primary),
      ),
      title: Text(
        account.type,
        style: textTheme.titleMedium?.copyWith(
          color: Palette(context).primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            account.number,
            style: textTheme.bodyMedium?.copyWith(
              color: Palette(context).onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            account.owner,
            style: textTheme.bodySmall?.copyWith(
              color: Palette(context).onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                account.balance,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Palette(context).secondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Icon(
            AntDesign.right_outline,
            size: 16,
            color: Palette(context).onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(child: cardContent),
    );
  }
}
