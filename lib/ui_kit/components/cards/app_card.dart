import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

enum AppCardVariant { surface, outlined, elevated }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.variant = AppCardVariant.surface,
    this.radius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final AppCardVariant variant;
  final double? radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius ?? AppT.r.md);

    final border = variant == AppCardVariant.outlined
        ? Border.all(color: AppT.c.divider)
        : null;

    final shadow = variant == AppCardVariant.elevated
        ? <BoxShadow>[AppT.sh.card]
        : const <BoxShadow>[];

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppT.c.surface,
        borderRadius: r,
        border: border,
        boxShadow: shadow,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: r,
        child: content,
      ),
    );
  }
}
