import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserManagementWidget extends StatefulWidget {
  const UserManagementWidget({super.key});

  @override
  State<UserManagementWidget> createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  final List<Map<String, dynamic>> pendingUsers = [
    {
      "id": "USR001",
      "name": "Chisomo Banda",
      "email": "chisomo.banda@gmail.com",
      "phone": "+265 991 234 567",
      "type": "User",
      "status": "Pending KYC",
      "joinDate": "2025-01-10",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "flagged": false,
    },
    {
      "id": "MER002",
      "name": "Mphatso Mwale",
      "email": "mphatso.trading@outlook.com",
      "phone": "+265 888 765 432",
      "type": "Merchant",
      "status": "Pending Approval",
      "joinDate": "2025-01-09",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "flagged": false,
    },
    {
      "id": "USR003",
      "name": "Thandiwe Phiri",
      "email": "thandiwe.phiri@yahoo.com",
      "phone": "+265 999 876 543",
      "type": "User",
      "status": "Flagged Account",
      "joinDate": "2025-01-08",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "flagged": true,
    },
    {
      "id": "MER004",
      "name": "Kondwani Nyirenda",
      "email": "kondwani.fx@gmail.com",
      "phone": "+265 881 234 567",
      "type": "Merchant",
      "status": "Verification Required",
      "joinDate": "2025-01-07",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "flagged": false,
    },
  ];

  void _approveUser(String userId) {
    setState(() {
      final userIndex = pendingUsers.indexWhere((user) => user["id"] == userId);
      if (userIndex != -1) {
        pendingUsers[userIndex]["status"] = "Approved";
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User $userId approved successfully"),
        backgroundColor: AppTheme.getSuccessColor(),
      ),
    );
  }

  void _rejectUser(String userId) {
    setState(() {
      pendingUsers.removeWhere((user) => user["id"] == userId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User $userId rejected"),
        backgroundColor: AppTheme.getErrorColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                "User Management",
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  "${pendingUsers.length} Pending",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
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
            itemCount: pendingUsers.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final user = pendingUsers[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (user["flagged"] as bool)
                        ? AppTheme.getErrorColor().withValues(alpha: 0.3)
                        : AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(3.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: CustomImageWidget(
                              imageUrl: user["avatar"] as String,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      user["name"] as String,
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
                                      color:
                                          (user["type"] as String) == "Merchant"
                                              ? AppTheme.lightTheme.primaryColor
                                                  .withValues(alpha: 0.1)
                                              : AppTheme.getSuccessColor()
                                                  .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      user["type"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: (user["type"] as String) ==
                                                "Merchant"
                                            ? AppTheme.lightTheme.primaryColor
                                            : AppTheme.getSuccessColor(),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                user["email"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                user["phone"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            decoration: BoxDecoration(
                              color: (user["flagged"] as bool)
                                  ? AppTheme.getErrorColor()
                                      .withValues(alpha: 0.1)
                                  : AppTheme.getWarningColor()
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user["status"] as String,
                              textAlign: TextAlign.center,
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: (user["flagged"] as bool)
                                    ? AppTheme.getErrorColor()
                                    : AppTheme.getWarningColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        GestureDetector(
                          onTap: () => _approveUser(user["id"] as String),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.getSuccessColor()
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.getSuccessColor()
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.getSuccessColor(),
                              size: 5.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        GestureDetector(
                          onTap: () => _rejectUser(user["id"] as String),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.getErrorColor()
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.getErrorColor()
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.getErrorColor(),
                              size: 5.w,
                            ),
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
