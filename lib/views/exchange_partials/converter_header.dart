import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

class ConverterHeader extends StatelessWidget {
  final VoidCallback onSwapPressed;

  const ConverterHeader({
    super.key,
    required this.onSwapPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Conversor de moneda",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Palette(context).primary,
                ),
              ),
              Text(
                "Digite el monto que desea convertir",
                style: TextStyle(
                  fontSize: 16,
                  color: Palette(context).primary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.swap_vert,
            size: 32,
            color: Palette(context).primary,
          ),
          onPressed: onSwapPressed,
        ),
      ],
    );
  }
}