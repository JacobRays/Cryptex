import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionProgressWidget extends StatefulWidget {
  final String currentStep;
  final VoidCallback onCancel;

  const TransactionProgressWidget({
    Key? key,
    required this.currentStep,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<TransactionProgressWidget> createState() =>
      _TransactionProgressWidgetState();
}

class _TransactionProgressWidgetState extends State<TransactionProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _steps = [
    {
      'id': 'secured',
      'title': 'USDT Secured',
      'description': 'Your USDT is held in escrow',
      'icon': 'lock',
    },
    {
      'id': 'processing',
      'title': 'Merchant Processing',
      'description': 'Merchant is preparing payment',
      'icon': 'hourglass_empty',
    },
    {
      'id': 'initiated',
      'title': 'Payment Initiated',
      'description': 'Mobile money transfer started',
      'icon': 'send',
    },
    {
      'id': 'completed',
      'title': 'Funds Received',
      'description': 'Transaction completed successfully',
      'icon': 'check_circle',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  int get _currentStepIndex {
    return _steps.indexWhere((step) => step['id'] == widget.currentStep);
  }

  bool _isStepCompleted(int index) {
    return index < _currentStepIndex;
  }

  bool _isStepActive(int index) {
    return index == _currentStepIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction Progress',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.currentStep != 'completed' && _currentStepIndex == 0)
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getErrorColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),

          // Progress Steps
          Column(
            children: _steps.asMap().entries.map((entry) {
              final int index = entry.key;
              final Map<String, dynamic> step = entry.value;
              final bool isCompleted = _isStepCompleted(index);
              final bool isActive = _isStepActive(index);
              final bool isLast = index == _steps.length - 1;

              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator
                      Column(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isActive ? _pulseAnimation.value : 1.0,
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppTheme.getSuccessColor()
                                        : isActive
                                            ? AppTheme.lightTheme.primaryColor
                                            : AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isCompleted
                                          ? AppTheme.getSuccessColor()
                                          : isActive
                                              ? AppTheme.lightTheme.primaryColor
                                              : AppTheme.lightTheme.colorScheme
                                                  .outline,
                                      width: 2,
                                    ),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: AppTheme
                                                  .lightTheme.primaryColor
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? CustomIconWidget(
                                            iconName: 'check',
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : CustomIconWidget(
                                            iconName: step['icon'] as String,
                                            color: isActive
                                                ? Colors.white
                                                : AppTheme.lightTheme
                                                    .colorScheme.outline,
                                            size: 20,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 6.h,
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppTheme.getSuccessColor()
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 4.w),

                      // Step content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: isCompleted || isActive
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                step['description'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (isActive &&
                                  widget.currentStep != 'completed') ...[
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4.w,
                                      height: 4.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppTheme.lightTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Processing...',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) SizedBox(height: 1.h),
                ],
              );
            }).toList(),
          ),

          if (widget.currentStep == 'completed') ...[
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.getSuccessColor().withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'celebration',
                    color: AppTheme.getSuccessColor(),
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Transaction completed successfully! Check your mobile money account.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.getSuccessColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
