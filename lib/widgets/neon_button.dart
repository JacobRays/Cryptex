import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const NeonButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.neon,
  }) : super(key: key);

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
