import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class KwachaCalculationWidget extends StatelessWidget {
  final double sellAmount;
  final double exchangeRate;
  final double merchantFee;
  final double networkFee;

  const KwachaCalculationWidget({
    Key? key,
    required this.sellAmount,
    required this.exchangeRate,
    required this.merchantFee,
    required this.networkFee,
  }) : super(key: key);

  double get grossAmount => sellAmount * exchangeRate;
  double get totalFees => merchantFee + networkFee;
  double get netAmount => grossAmount - totalFees;

  @override
  Widget build(BuildContext context) {
    return sellAmount > 0
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.getSuccessColor().withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.getSuccessColor().withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
                      'You will receive',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.getSuccessColor(),
                      size: 20,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'MWK ${netAmount.toStringAsFixed(2)}',
                    style: AppTheme.getDataTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.getSuccessColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildCalculationRow(
                    'Gross Amount', 'MWK ${grossAmount.toStringAsFixed(2)}'),
                _buildCalculationRow(
                    'Merchant Fee', '- MWK ${merchantFee.toStringAsFixed(2)}'),
                _buildCalculationRow(
                    'Network Fee', '- MWK ${networkFee.toStringAsFixed(2)}'),
                Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  thickness: 1,
                  height: 2.h,
                ),
                _buildCalculationRow(
                  'Net Amount',
                  'MWK ${netAmount.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildCalculationRow(String label, String amount,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isTotal
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: AppTheme.getDataTextStyle(
              fontSize: isTotal ? 14.sp : 12.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal
                  ? AppTheme.getSuccessColor()
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
