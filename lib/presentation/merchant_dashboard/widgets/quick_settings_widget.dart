import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> settingsData;
  final Function(String, dynamic) onSettingChanged;

  const QuickSettingsWidget({
    Key? key,
    required this.settingsData,
    required this.onSettingChanged,
  }) : super(key: key);

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
          Text(
            'Quick Settings',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.getPrimaryColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildSettingItem(
            'Auto-Approval',
            'Automatically approve transactions under threshold',
            'autoApproval',
            settingsData['autoApproval'] as bool? ?? false,
            isSwitch: true,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Push Notifications',
            'Receive notifications for new transactions',
            'pushNotifications',
            settingsData['pushNotifications'] as bool? ?? true,
            isSwitch: true,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Auto-Approval Threshold',
            'Maximum amount for auto-approval (\$)',
            'autoApprovalThreshold',
            (settingsData['autoApprovalThreshold'] as double? ?? 100.0)
                .toStringAsFixed(0),
            isInput: true,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Availability Schedule',
            'Set your working hours',
            'schedule',
            'Configure',
            isButton: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String description,
    String key,
    dynamic value, {
    bool isSwitch = false,
    bool isInput = false,
    bool isButton = false,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
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
          SizedBox(width: 3.w),
          if (isSwitch)
            Switch(
              value: value as bool,
              onChanged: (newValue) => onSettingChanged(key, newValue),
            )
          else if (isInput)
            GestureDetector(
              onTap: () => _showInputDialog(title, key, value as String),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.getPrimaryColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '\$${value}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.getPrimaryColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else if (isButton)
            GestureDetector(
              onTap: () => _showScheduleDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getAccentColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.getAccentColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.getAccentColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.getAccentColor(),
                      size: 3.w,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showInputDialog(String title, String key, String currentValue) {
    // This would show a dialog for input - implementation depends on context
    // For now, we'll simulate the callback
    final newValue = double.tryParse(currentValue) ?? 0.0;
    onSettingChanged(key, newValue + 50); // Example increment
  }

  void _showScheduleDialog() {
    // This would show a schedule configuration dialog
    // Implementation would depend on the specific requirements
    onSettingChanged('schedule', 'Updated');
  }
}
