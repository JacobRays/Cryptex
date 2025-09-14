import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtonWidget extends StatefulWidget {
  final String title;
  final String iconName;
  final VoidCallback onPressed;
  final bool isPrimary;

  const QuickActionButtonWidget({
    Key? key,
    required this.title,
    required this.iconName,
    required this.onPressed,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  State<QuickActionButtonWidget> createState() =>
      _QuickActionButtonWidgetState();
}

class _QuickActionButtonWidgetState extends State<QuickActionButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 42.w,
              height: 12.h,
              decoration: BoxDecoration(
                gradient: widget.isPrimary
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.lightTheme.primaryColor,
                          AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.8),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.lightTheme.colorScheme.surface,
                          AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.8),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isPrimary
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: widget.iconName,
                    color: widget.isPrimary
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.primaryColor,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: widget.isPrimary
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
