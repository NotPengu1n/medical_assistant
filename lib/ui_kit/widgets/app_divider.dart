// lib/ui_kit/widgets/app_divider.dart
import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Брендовый разделитель.
///
/// Использование:
/// - const AppDivider()                         // с вертикальными отступами по умолчанию
/// - const AppDivider(vertical: false)          // без вертикальных отступов (плотно)
/// - AppDivider(margin: EdgeInsets.zero)        // полный контроль
/// - const AppDivider(indent: 16, endIndent: 16)
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.margin,
    this.vertical = true,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  /// Внешние отступы вокруг линии. Если не задано — берём дефолт из токенов.
  final EdgeInsets? margin;

  /// Если true — добавляет вертикальные отступы (дефолтный разделитель между блоками).
  /// Если false — отступов нет (удобно внутри списков/между секциями).
  final bool vertical;

  /// Толщина линии.
  final double thickness;

  /// Отступ линии слева.
  final double indent;

  /// Отступ линии справа.
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final m = margin ?? (vertical ? EdgeInsets.symmetric(vertical: AppT.s.md) : EdgeInsets.zero);

    return Padding(
      padding: m,
      child: Padding(
        padding: EdgeInsets.only(left: indent, right: endIndent),
        child: SizedBox(
          height: thickness,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppT.c.divider,
            ),
          ),
        ),
      ),
    );
  }
}
