import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const BusinessMetricsWidget({
    Key? key,
    required this.metricsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Metrics',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.getPrimaryColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Today\'s Transactions',
                metricsData['todayTransactions']?.toString() ?? '0',
                'transactions',
                AppTheme.getPrimaryColor(),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildMetricCard(
                'Total Volume',
                '\$${metricsData['totalVolume']?.toStringAsFixed(2) ?? '0.00'}',
                'volume',
                AppTheme.getSuccessColor(),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Today\'s Earnings',
                '\$${metricsData['todayEarnings']?.toStringAsFixed(2) ?? '0.00'}',
                'earnings',
                AppTheme.getWarningColor(),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildMetricCard(
                'Completion Rate',
                '${metricsData['completionRate']?.toStringAsFixed(1) ?? '0.0'}%',
                'rate',
                AppTheme.getAccentColor(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, String type, Color accentColor) {
    IconData iconData;
    switch (type) {
      case 'transactions':
        iconData = Icons.swap_horiz;
        break;
      case 'volume':
        iconData = Icons.trending_up;
        break;
      case 'earnings':
        iconData = Icons.account_balance_wallet;
        break;
      case 'rate':
        iconData = Icons.check_circle_outline;
        break;
      default:
        iconData = Icons.analytics;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: iconData.codePoint.toString(),
                color: accentColor,
                size: 6.w,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Today',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
