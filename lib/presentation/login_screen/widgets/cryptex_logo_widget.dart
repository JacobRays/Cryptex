import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CryptexLogoWidget extends StatelessWidget {
  const CryptexLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          // Logo Container with Glow Effect
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  'C',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // App Name
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.7),
              ],
            ).createShader(bounds),
            child: Text(
              'CRYPTEX',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                fontSize: 20.sp,
              ),
            ),
          ),

          // Subtitle
          Text(
            'MALAWI',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              letterSpacing: 1.5,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
