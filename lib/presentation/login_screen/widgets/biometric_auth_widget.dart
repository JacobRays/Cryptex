import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatelessWidget {
  final VoidCallback onBiometricPressed;
  final bool isAvailable;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricPressed,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBiometricPressed,
                borderRadius: BorderRadius.circular(50),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'fingerprint',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Use Biometric',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
