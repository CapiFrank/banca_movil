import 'package:flutter/material.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/elevated_flex_container.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;

  const AccountCard({super.key, required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ElevatedFlexContainer.horizontal(
          onTap: onTap,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(16.0),
          elevation: 2.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.type,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette(context).primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Número: ${account.number}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette(context).primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Titular: ${account.owner}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette(context).primary,
                  ),
                ),
              ],
            ),
            Text(
              account.balance,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Palette(context).primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
