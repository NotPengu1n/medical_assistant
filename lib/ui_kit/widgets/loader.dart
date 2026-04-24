import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 24, this.center = true});

  final double size;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppT.c.primary,
      ),
    );

    return center ? Center(child: indicator) : indicator;
  }
}
