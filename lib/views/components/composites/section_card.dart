import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/base_card.dart';
import 'package:banca_movil/views/components/primitives/square_avatar.dart';
import 'package:flutter/material.dart';

enum WrapperType { sliver, normal }

class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final EdgeInsets? margin;
  final IconData? icon;
  final void Function()? onTap;
  final Widget? trailing;
  final WrapperType wrapperType;
  const SectionCard({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.margin,
    this.icon,
    this.onTap,
    this.trailing,
    this.wrapperType = WrapperType.sliver,
  });

  @override
  Widget build(BuildContext context) {
    if (wrapperType == WrapperType.sliver) {
      return SliverToBoxAdapter(child: _buildBaseContent(context));
    } else {
      return _buildBaseContent(context);
    }
  }

  Widget _buildBaseContent(BuildContext context) {
    return BaseCard(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.0),
      leading: SquareAvatar(
        child: Icon(icon, color: Palette(context).primary, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Palette(context).onSurface.withValues(alpha: 0.5),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
