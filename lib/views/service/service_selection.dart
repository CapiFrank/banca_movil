import 'package:banca_movil/utils/styles.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/elevated_flex_container.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ServiceSelection extends StatefulWidget {
  const ServiceSelection({super.key});

  @override
  State<ServiceSelection> createState() => _ServiceSelectionState();
}

class _ServiceSelectionState extends State<ServiceSelection> {
  @override
  Widget build(BuildContext context) {
    return ScrollLayout.parent(
      children: [
        _buildSectionTitle('¿Qué servicio desea pagar?'),
        SliverToBoxAdapter(
          child: Row(
            children: [
              _buildServiceCard(
                MingCute.star_line,
                'Favoritos',
                EdgeInsets.fromLTRB(16, 0, 8, 16),
              ),
              _buildServiceCard(
                MingCute.bill_line,
                'Cuotas',
                EdgeInsets.fromLTRB(8, 0, 16, 16),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              _buildServiceCard(
                MingCute.bulb_line,
                'Electricidad',
                EdgeInsets.fromLTRB(16, 0, 8, 16),
              ),
              _buildServiceCard(
                MingCute.drop_line,
                'Agua',
                EdgeInsets.fromLTRB(8, 0, 16, 16),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              _buildServiceCard(
                MingCute.tv_1_line,
                'Televisión/Internet',
                EdgeInsets.fromLTRB(16, 0, 8, 16),
              ),
              _buildServiceCard(
                MingCute.phone_line,
                'Teléfono',
                EdgeInsets.fromLTRB(8, 0, 16, 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(title, style: sectionTitleStyle),
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, EdgeInsets margin) {
    return Expanded(
      child: ElevatedFlexContainer.vertical(
        margin: margin,
        elevation: 0.02,
        borderRadius: BorderRadius.circular(8),
        children: [
          Icon(icon, color: Palette(context).primary, size: 28),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
