import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

enum AppIconButtonShape { circle, rounded }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 48,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
    this.shape = AppIconButtonShape.circle,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final AppIconButtonShape shape;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppT.c.surface;
    final fg = iconColor ?? AppT.c.textPrimary;

    final BorderRadius? br = shape == AppIconButtonShape.rounded
        ? BorderRadius.circular(AppT.r.lg)
        : null;

    return Material(
      color: bg,
      shape: shape == AppIconButtonShape.circle ? const CircleBorder() : null,
      borderRadius: br,
      child: InkWell(
        onTap: onTap,
        customBorder: shape == AppIconButtonShape.circle ? const CircleBorder() : null,
        borderRadius: br,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: iconSize, color: fg),
        ),
      ),
    );
  }
}
