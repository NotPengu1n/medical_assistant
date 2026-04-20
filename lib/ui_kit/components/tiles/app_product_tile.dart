import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../buttons/app_icon_button.dart';

class AppProductTile extends StatelessWidget {
  const AppProductTile({
    super.key,
    required this.title,
    required this.price,
    this.onAdd,
  });

  final String title;
  final String price;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppT.c.surface,
      borderRadius: BorderRadius.circular(AppT.r.md),
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(AppT.r.md),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 4),
                    Text(price,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppT.c.textSecondary,
                        )),
                  ],
                ),
              ),
              AppIconButton(
                icon: Icons.add,
                onTap: onAdd,
                backgroundColor: AppT.c.background,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
