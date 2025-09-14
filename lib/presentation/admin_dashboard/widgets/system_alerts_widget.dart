import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SystemAlertsWidget extends StatefulWidget {
  const SystemAlertsWidget({super.key});

  @override
  State<SystemAlertsWidget> createState() => _SystemAlertsWidgetState();
}

class _SystemAlertsWidgetState extends State<SystemAlertsWidget> {
  final List<Map<String, dynamic>> systemAlerts = [
    {
      "id": "ALT001",
      "title": "High Transaction Volume",
      "message":
          "Transaction volume exceeded 150% of daily average. System performance may be affected.",
      "priority": "High",
      "type": "Performance",
      "timestamp": "2025-01-11 13:45:22",
      "status": "Active",
      "icon": "trending_up",
    },
    {
      "id": "ALT002",
      "title": "API Rate Limit Warning",
      "message":
          "Airtel Money API approaching rate limit (85% usage). Consider implementing request throttling.",
      "priority": "Medium",
      "type": "API",
      "timestamp": "2025-01-11 12:30:15",
      "status": "Active",
      "icon": "api",
    },
    {
      "id": "ALT003",
      "title": "Suspicious Activity Detected",
      "message":
          "Multiple failed login attempts from IP 192.168.1.100. User account temporarily locked.",
      "priority": "Critical",
      "type": "Security",
      "timestamp": "2025-01-11 11:22:08",
      "status": "Resolved",
      "icon": "security",
    },
    {
      "id": "ALT004",
      "title": "Database Connection Slow",
      "message":
          "Database response time increased by 40%. Consider optimizing queries or scaling resources.",
      "priority": "Medium",
      "type": "Database",
      "timestamp": "2025-01-11 10:15:33",
      "status": "Active",
      "icon": "storage",
    },
    {
      "id": "ALT005",
      "title": "Scheduled Maintenance",
      "message":
          "System maintenance scheduled for 2025-01-12 02:00 AM. Expected downtime: 2 hours.",
      "priority": "Low",
      "type": "Maintenance",
      "timestamp": "2025-01-11 09:00:00",
      "status": "Scheduled",
      "icon": "build",
    },
  ];

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return AppTheme.getErrorColor();
      case 'high':
        return AppTheme.getWarningColor();
      case 'medium':
        return AppTheme.lightTheme.primaryColor;
      case 'low':
        return AppTheme.getSuccessColor();
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.getErrorColor();
      case 'resolved':
        return AppTheme.getSuccessColor();
      case 'scheduled':
        return AppTheme.lightTheme.primaryColor;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _dismissAlert(String alertId) {
    setState(() {
      final alertIndex =
          systemAlerts.indexWhere((alert) => alert["id"] == alertId);
      if (alertIndex != -1) {
        systemAlerts[alertIndex]["status"] = "Resolved";
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Alert $alertId dismissed"),
        backgroundColor: AppTheme.getSuccessColor(),
      ),
    );
  }

  void _viewAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: alert["icon"] as String,
              color: _getPriorityColor(alert["priority"] as String),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                alert["title"] as String,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getPriorityColor(alert["priority"] as String)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${alert["priority"]} Priority",
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _getPriorityColor(alert["priority"] as String),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              alert["message"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Type: ${alert["type"]}",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  alert["timestamp"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
          if ((alert["status"] as String).toLowerCase() == "active")
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _dismissAlert(alert["id"] as String);
              },
              child: const Text("Resolve"),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeAlerts = systemAlerts
        .where((alert) => (alert["status"] as String).toLowerCase() == "active")
        .length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "System Alerts",
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: activeAlerts > 0
                      ? AppTheme.getErrorColor().withValues(alpha: 0.1)
                      : AppTheme.getSuccessColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: activeAlerts > 0
                        ? AppTheme.getErrorColor().withValues(alpha: 0.3)
                        : AppTheme.getSuccessColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  "$activeAlerts Active",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: activeAlerts > 0
                        ? AppTheme.getErrorColor()
                        : AppTheme.getSuccessColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: systemAlerts.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final alert = systemAlerts[index];
              return GestureDetector(
                onTap: () => _viewAlertDetails(alert),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getPriorityColor(alert["priority"] as String)
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color:
                                  _getPriorityColor(alert["priority"] as String)
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: alert["icon"] as String,
                              color: _getPriorityColor(
                                  alert["priority"] as String),
                              size: 5.w,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        alert["title"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                                alert["status"] as String)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        alert["status"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: _getStatusColor(
                                              alert["status"] as String),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.5.w, vertical: 0.3.h),
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor(
                                                alert["priority"] as String)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        alert["priority"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: _getPriorityColor(
                                              alert["priority"] as String),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      alert["type"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
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
                      Text(
                        alert["message"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            alert["timestamp"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if ((alert["status"] as String).toLowerCase() ==
                              "active")
                            GestureDetector(
                              onTap: () => _dismissAlert(alert["id"] as String),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.getSuccessColor()
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.getSuccessColor()
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  "Resolve",
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.getSuccessColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
