import 'package:flutter/material.dart';
import '../../../../ui_kit/theme/tokens.dart';

class BrandStartView extends StatefulWidget {
  const BrandStartView({
    super.key,
    required this.title,
    required this.logoLightAsset,
    required this.logoDarkAsset,
    this.subtitle,
  });

  final String title;
  final String logoLightAsset;
  final String logoDarkAsset;
  final String? subtitle;

  @override
  State<BrandStartView> createState() => _BrandStartViewState();
}

class _BrandStartViewState extends State<BrandStartView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  late final Animation<double> _fade =
  CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  late final Animation<double> _scale = Tween<double>(begin: 0.92, end: 1.0)
      .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final logo = isDark ? widget.logoDarkAsset : widget.logoLightAsset;

    return DecoratedBox(
      decoration: BoxDecoration(
        // Важно: только через BrandThemeAdapter/AppT
        gradient: AppT.c.brandGradient,
      ),
      child: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Padding(
                padding: EdgeInsets.all(AppT.s.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Логотип
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Image.asset(logo, fit: BoxFit.contain),
                    ),

                    SizedBox(height: AppT.s.lg),

                    // Название
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    if (widget.subtitle != null) ...[
                      SizedBox(height: AppT.s.sm),
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],

                    SizedBox(height: AppT.s.xl),

                    // Лоадер
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
