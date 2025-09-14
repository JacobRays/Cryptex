import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EarningsSummaryWidget extends StatefulWidget {
  final Map<String, dynamic> earningsData;
  final Function(String) onWithdraw;

  const EarningsSummaryWidget({
    Key? key,
    required this.earningsData,
    required this.onWithdraw,
  }) : super(key: key);

  @override
  State<EarningsSummaryWidget> createState() => _EarningsSummaryWidgetState();
}

class _EarningsSummaryWidgetState extends State<EarningsSummaryWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Daily';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showWithdrawOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: AppTheme.getPrimaryColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  Text(
                    'Withdraw Earnings',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.getPrimaryColor(),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Available: \$${(widget.earningsData['availableBalance'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.getSuccessColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildWithdrawOption(
                      'Airtel Money', 'Instant withdrawal to Airtel Money'),
                  SizedBox(height: 2.h),
                  _buildWithdrawOption(
                      'Mpamba', 'Instant withdrawal to Mpamba'),
                  SizedBox(height: 2.h),
                  _buildWithdrawOption(
                      'Bank Transfer', 'Manual bank transfer (1-3 days)'),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawOption(String method, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        widget.onWithdraw(method);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: method == 'Bank Transfer'
                    ? 'account_balance'
                    : 'phone_android',
                color: AppTheme.getPrimaryColor(),
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.getPrimaryColor().withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
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
                'Earnings Summary',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.getPrimaryColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: _showWithdrawOptions,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.getSuccessColor().withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: AppTheme.getSuccessColor(),
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Withdraw',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.getSuccessColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
              ],
              onTap: (index) {
                setState(() {
                  _selectedPeriod = ['Daily', 'Weekly', 'Monthly'][index];
                });
              },
            ),
          ),
          SizedBox(height: 3.h),
          Container(
            height: 20.h,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEarningsView('daily'),
                _buildEarningsView('weekly'),
                _buildEarningsView('monthly'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsView(String period) {
    final earnings = widget.earningsData[period] as Map<String, dynamic>? ?? {};
    final totalEarnings = earnings['total'] as double? ?? 0.0;
    final transactions = earnings['transactions'] as int? ?? 0;
    final fees = earnings['fees'] as double? ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildEarningsCard(
                'Total Earnings',
                '\$${totalEarnings.toStringAsFixed(2)}',
                AppTheme.getSuccessColor(),
                'trending_up',
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildEarningsCard(
                'Transactions',
                transactions.toString(),
                AppTheme.getPrimaryColor(),
                'swap_horiz',
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        Row(
          children: [
            Expanded(
              child: _buildEarningsCard(
                'Fees Collected',
                '\$${fees.toStringAsFixed(2)}',
                AppTheme.getWarningColor(),
                'account_balance',
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildEarningsCard(
                'Available',
                '\$${(widget.earningsData['availableBalance'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                AppTheme.getAccentColor(),
                'account_balance_wallet',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsCard(
      String title, String value, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 5.w,
              ),
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
