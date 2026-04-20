import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 24});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppT.c.primary,
      ),
    );
  }
}
