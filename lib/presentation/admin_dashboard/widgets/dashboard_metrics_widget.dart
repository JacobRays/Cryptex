import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardMetricsWidget extends StatelessWidget {
  const DashboardMetricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> metricsData = [
      {
        "title": "Total Users",
        "value": "12,847",
        "change": "+8.2%",
        "isPositive": true,
        "icon": "people",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "title": "Active Merchants",
        "value": "342",
        "change": "+12.5%",
        "isPositive": true,
        "icon": "store",
        "color": AppTheme.lightTheme.primaryColor,
      },
      {
        "title": "Daily Volume",
        "value": "\$847,293",
        "change": "-2.1%",
        "isPositive": false,
        "icon": "trending_up",
        "color": AppTheme.getWarningColor(),
      },
      {
        "title": "System Health",
        "value": "99.8%",
        "change": "+0.1%",
        "isPositive": true,
        "icon": "health_and_safety",
        "color": AppTheme.getSuccessColor(),
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Platform Overview",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.6,
            ),
            itemCount: metricsData.length,
            itemBuilder: (context, index) {
              final metric = metricsData[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconWidget(
                          iconName: metric["icon"] as String,
                          color: metric["color"] as Color,
                          size: 6.w,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: (metric["isPositive"] as bool)
                                ? AppTheme.getSuccessColor()
                                    .withValues(alpha: 0.1)
                                : AppTheme.getErrorColor()
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            metric["change"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: (metric["isPositive"] as bool)
                                  ? AppTheme.getSuccessColor()
                                  : AppTheme.getErrorColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric["value"] as String,
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          metric["title"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
