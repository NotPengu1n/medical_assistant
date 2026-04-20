import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

enum AppButtonVariant { primary, secondary, ghost }
enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;
  final bool expand;

  double get _h => switch (size) {
    AppButtonSize.sm => 40,
    AppButtonSize.md => 48,
    AppButtonSize.lg => 56,
  };

  EdgeInsets get _pad => switch (size) {
    AppButtonSize.sm => const EdgeInsets.symmetric(horizontal: 14),
    AppButtonSize.md => const EdgeInsets.symmetric(horizontal: 16),
    AppButtonSize.lg => const EdgeInsets.symmetric(horizontal: 18),
  };

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    final bg = switch (variant) {
      AppButtonVariant.primary => AppT.c.primary,
      AppButtonVariant.secondary => AppT.c.surfaceVariant,
      AppButtonVariant.ghost => Colors.transparent,
    };

    final fg = switch (variant) {
      AppButtonVariant.primary => Colors.white,
      _ => AppT.c.textPrimary,
    };

    final border = variant == AppButtonVariant.ghost
        ? Border.all(color: AppT.c.divider)
        : null;

    final radius = BorderRadius.circular(AppT.r.lg);

    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          ),
          const SizedBox(width: 10),
        ] else if (leading != null) ...[
          IconTheme(data: IconThemeData(color: fg), child: leading!),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: fg, fontWeight: FontWeight.w600),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          IconTheme(data: IconThemeData(color: fg), child: trailing!),
        ],
      ],
    );

    final btn = Material(
      color: bg,
      borderRadius: radius,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: radius,
        child: Container(
          height: _h,
          padding: _pad,
          decoration: BoxDecoration(borderRadius: radius, border: border),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
