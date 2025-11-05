import 'package:banca_movil/bloc/payment/payment_bloc.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/views/components/composites/section_card.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class TransferSelectDestinationMethod extends StatefulWidget {
  const TransferSelectDestinationMethod({super.key});

  @override
  State<TransferSelectDestinationMethod> createState() =>
      _TransferSelectDestinationMethodState();
}

class _TransferSelectDestinationMethodState
    extends State<TransferSelectDestinationMethod> {
      
  void _navigateToSelectSourceAccount(PaymentMethod paymentMethod) {
    context.read<PaymentBloc>().add(SetPaymentMethodRequested(paymentMethod));
    context.push('/transfer/selectsourceaccount');
  }

  @override
  Widget build(BuildContext context) {
    return ScrollLayout.parent(
      title: 'Enviar dinero',
      children: [
        SectionCard(
          title: 'Entre cuentas',
          subtitle: 'Envía dinero a otras cuentas del mismo banco',
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          icon: Clarity.bank_solid,
          onTap: () => _navigateToSelectSourceAccount(PaymentMethod.sameBank),
        ),
        SectionCard(
          title: 'Otros bancos (SINPE)',
          subtitle: 'Envía dinero a otras cuentas bancarias',
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          icon: Clarity.bank_solid,
          onTap: () => _navigateToSelectSourceAccount(PaymentMethod.sinpe),
        ),
        SectionCard(
          title: 'SINPE Móvil',
          subtitle: 'Envía dinero a través de un número de teléfono',
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          icon: MingCute.phone_line,
          onTap: () => _navigateToSelectSourceAccount(PaymentMethod.sinpeMovil),
        ),
      ],
    );
  }
}
