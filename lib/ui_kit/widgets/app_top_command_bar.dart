import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../ui_kit.dart';

/// Единая верхняя командная панель (v3) как на расписании:
/// [Back] — заголовок — [Refresh].
///
/// Если onBack/onRefresh == null, иконка не показывается, но место сохраняется
/// (чтобы заголовок оставался строго по центру).
class AppTopCommandBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onRefresh;

  const AppTopCommandBar({
    super.key,
    required this.title,
    this.onBack,
    this.onRefresh,
  });

  static const double _btnSize = 44;
  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    Widget left() {
      if (onBack == null) return const SizedBox(width: _btnSize, height: _btnSize);
      return AppIconButton(
        icon: LucideIcons.chevron_left,
        onTap: onBack!,
        backgroundColor: AppT.c.surface,
        iconColor: AppT.c.textPrimary,
        size: _btnSize,
        iconSize: _iconSize,
      );
    }

    Widget right() {
      if (onRefresh == null) return const SizedBox(width: _btnSize, height: _btnSize);
      return AppIconButton(
        icon: LucideIcons.refresh_cw,
        onTap: onRefresh!,
        backgroundColor: AppT.c.surface,
        iconColor: AppT.c.textPrimary,
        size: _btnSize,
        iconSize: _iconSize,
      );
    }

    return Row(
      children: [
        left(),
        SizedBox(width: AppT.s.md),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppT.c.textPrimary,
            ),
          ),
        ),
        SizedBox(width: AppT.s.md),
        right(),
      ],
    );
  }
}
