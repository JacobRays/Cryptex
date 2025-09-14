import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionProgressWidget extends StatefulWidget {
  final String currentStatus;
  final VoidCallback? onCancel;

  const TransactionProgressWidget({
    Key? key,
    required this.currentStatus,
    this.onCancel,
  }) : super(key: key);

  @override
  State<TransactionProgressWidget> createState() =>
      _TransactionProgressWidgetState();
}

class _TransactionProgressWidgetState extends State<TransactionProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _progressSteps = [
    {
      'id': 'payment_pending',
      'title': 'Payment Pending',
      'description': 'Waiting for payment confirmation',
      'icon': 'payment',
    },
    {
      'id': 'merchant_confirmation',
      'title': 'Merchant Confirmation',
      'description': 'Merchant is processing your payment',
      'icon': 'person_check',
    },
    {
      'id': 'usdt_transfer',
      'title': 'USDT Transfer',
      'description': 'Transferring USDT to your wallet',
      'icon': 'swap_horiz',
    },
    {
      'id': 'complete',
      'title': 'Complete',
      'description': 'Transaction completed successfully',
      'icon': 'check_circle',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'timeline',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Progress',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Track your transaction status',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Progress Steps
          Column(
            children: _progressSteps.asMap().entries.map((entry) {
              final int index = entry.key;
              final Map<String, dynamic> step = entry.value;
              final bool isCompleted = _isStepCompleted(step['id']);
              final bool isCurrent = step['id'] == widget.currentStatus;
              final bool isLast = index == _progressSteps.length - 1;

              return Column(
                children: [
                  Row(
                    children: [
                      // Step indicator
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isCurrent ? _pulseAnimation.value : 1.0,
                            child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted || isCurrent
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.surface,
                                border: Border.all(
                                  color: isCompleted || isCurrent
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: AppTheme
                                              .lightTheme.primaryColor
                                              .withValues(alpha: 0.4),
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
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 20,
                                      )
                                    : CustomIconWidget(
                                        iconName: step['icon'],
                                        color: isCurrent
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.5),
                                        size: 20,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(width: 4.w),

                      // Step content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isCompleted || isCurrent
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              step['description'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status indicator
                      if (isCurrent)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.getWarningColor()
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.getWarningColor()
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'In Progress',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.getWarningColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else if (isCompleted)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor()
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.getSuccessColor()
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Completed',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.getSuccessColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Connector line
                  if (!isLast)
                    Container(
                      margin: EdgeInsets.only(left: 6.w, top: 2.h, bottom: 2.h),
                      width: 2,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),

          // Cancel button (only show if transaction can be cancelled)
          if (widget.onCancel != null && _canCancelTransaction())
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  side: BorderSide(
                    color: AppTheme.getErrorColor(),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'cancel',
                      color: AppTheme.getErrorColor(),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Cancel Transaction',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.getErrorColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isStepCompleted(String stepId) {
    final currentIndex =
        _progressSteps.indexWhere((step) => step['id'] == widget.currentStatus);
    final stepIndex = _progressSteps.indexWhere((step) => step['id'] == stepId);
    return stepIndex < currentIndex;
  }

  bool _canCancelTransaction() {
    return widget.currentStatus == 'payment_pending';
  }
}
