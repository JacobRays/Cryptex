import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight weight;

  const NeonText({
    Key? key,
    required this.text,
    this.fontSize = 20,
    this.color = AppColors.neon,
    this.weight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: weight,
        color: color,
        shadows: [
          Shadow(blurRadius: 12, color: color.withOpacity(0.6), offset: const Offset(0, 0)),
        ],
      ),
    );
  }
}
