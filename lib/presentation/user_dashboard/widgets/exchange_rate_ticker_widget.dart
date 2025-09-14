import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExchangeRateTickerWidget extends StatefulWidget {
  final String rate;
  final String changePercentage;
  final bool isPositive;

  const ExchangeRateTickerWidget({
    Key? key,
    required this.rate,
    required this.changePercentage,
    required this.isPositive,
  }) : super(key: key);

  @override
  State<ExchangeRateTickerWidget> createState() =>
      _ExchangeRateTickerWidgetState();
}

class _ExchangeRateTickerWidgetState extends State<ExchangeRateTickerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: widget.isPositive
                      ? AppTheme.getSuccessColor()
                      : AppTheme.getErrorColor(),
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'USDT/MWK: ${widget.rate}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: widget.isPositive
                        ? AppTheme.getSuccessColor().withValues(alpha: 0.2)
                        : AppTheme.getErrorColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.isPositive ? '+' : ''}${widget.changePercentage}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: widget.isPositive
                          ? AppTheme.getSuccessColor()
                          : AppTheme.getErrorColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
