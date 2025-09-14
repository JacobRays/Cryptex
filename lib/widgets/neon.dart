import 'package:flutter/material.dart';
import '../theme.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight weight;

  const NeonText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color = AppColors.neon,
    this.weight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: weight,
        color: color,
        shadows: [
          Shadow(
            blurRadius: 12,
            color: color.withOpacity(0.6),
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.neon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 8,
        shadowColor: color.withOpacity(0.6),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
