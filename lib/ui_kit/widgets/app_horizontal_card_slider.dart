import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class AppHorizontalCardSlider extends StatelessWidget {
  const AppHorizontalCardSlider({
    super.key,
    required this.title,
    required this.items,
    this.onMoreTap,
    this.padding,
    this.height = 120,
    this.moreText = 'Все',
  });

  final String title;
  final List<Widget> items;
  final VoidCallback? onMoreTap;
  final EdgeInsetsGeometry? padding;

  /// Высота списка (оставил 120 как у тебя).
  final double height;

  /// Текст кнопки "Все".
  final String moreText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final text = Theme.of(context).textTheme;
    final hasTitle = title.trim().isNotEmpty;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasTitle) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppT.c.textPrimary,
                    ),
                  ),
                ),
                if (onMoreTap != null)
                  TextButton(
                    onPressed: onMoreTap,
                    style: TextButton.styleFrom(
                      foregroundColor: AppT.c.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(moreText),
                  ),
              ],
            ),
            SizedBox(height: AppT.s.sm),
          ],
          SizedBox(
            height: height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width: AppT.s.sm),
              itemBuilder: (context, index) => items[index],
            ),
          ),
        ],
      ),
    );
  }
}
