import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color borderColor;
  final double elevation;

  const NeonCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 12,
    this.borderColor = AppColors.border,
    this.elevation = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: elevation,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
