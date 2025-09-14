import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MerchantCardWidget extends StatelessWidget {
  final Map<String, dynamic> merchant;
  final bool isSelected;
  final VoidCallback onTap;

  const MerchantCardWidget({
    Key? key,
    required this.merchant,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return AppTheme.getSuccessColor();
      case 'busy':
        return AppTheme.getWarningColor();
      case 'offline':
        return AppTheme.getErrorColor();
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status =
        (merchant['status'] as String? ?? 'offline').toLowerCase();
    final double rate = merchant['buyRate'] as double? ?? 0.0;
    final int processingTime = merchant['processingTime'] as int? ?? 0;
    final double reliability = merchant['reliabilityScore'] as double? ?? 0.0;
    final String name = merchant['name'] as String? ?? 'Unknown Merchant';
    final String avatar = merchant['avatar'] as String? ?? '';

    return GestureDetector(
      onTap: status == 'online' ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : status == 'online'
                    ? AppTheme.getSuccessColor().withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Opacity(
          opacity: status == 'online' ? 1.0 : 0.6,
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.surface,
                        child: avatar.isNotEmpty
                            ? CustomImageWidget(
                                imageUrl: avatar,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.cover,
                              )
                            : CustomIconWidget(
                                iconName: 'person',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 6.w,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.getWarningColor(),
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${reliability.toStringAsFixed(1)}/5.0',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getStatusColor(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    'Buy Rate',
                    'MWK ${rate.toStringAsFixed(2)}',
                    CustomIconWidget(
                      iconName: 'trending_up',
                      color: AppTheme.getSuccessColor(),
                      size: 16,
                    ),
                  ),
                  _buildInfoItem(
                    'Processing',
                    '~${processingTime}min',
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                  ),
                ],
              ),
              if (status != 'online') ...[
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status == 'busy'
                        ? 'Merchant is currently busy'
                        : 'Merchant is offline',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Widget icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.getDataTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
