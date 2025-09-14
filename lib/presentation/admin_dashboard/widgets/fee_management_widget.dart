import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeeManagementWidget extends StatefulWidget {
  const FeeManagementWidget({super.key});

  @override
  State<FeeManagementWidget> createState() => _FeeManagementWidgetState();
}

class _FeeManagementWidgetState extends State<FeeManagementWidget> {
  final TextEditingController _userFeeController = TextEditingController();
  final TextEditingController _merchantFeeController = TextEditingController();

  double userToMerchantFee = 0.50;
  double merchantToMerchantFee = 1.00;
  bool isUpdating = false;

  final List<Map<String, dynamic>> feeHistory = [
    {
      "date": "2025-01-11 10:30:00",
      "type": "User to Merchant",
      "oldFee": 0.45,
      "newFee": 0.50,
      "updatedBy": "Admin",
    },
    {
      "date": "2025-01-08 14:15:00",
      "type": "Merchant to Merchant",
      "oldFee": 0.90,
      "newFee": 1.00,
      "updatedBy": "Admin",
    },
    {
      "date": "2025-01-05 09:20:00",
      "type": "User to Merchant",
      "oldFee": 0.40,
      "newFee": 0.45,
      "updatedBy": "System",
    },
  ];

  @override
  void initState() {
    super.initState();
    _userFeeController.text = userToMerchantFee.toStringAsFixed(2);
    _merchantFeeController.text = merchantToMerchantFee.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _userFeeController.dispose();
    _merchantFeeController.dispose();
    super.dispose();
  }

  void _updateFees() async {
    final newUserFee = double.tryParse(_userFeeController.text);
    final newMerchantFee = double.tryParse(_merchantFeeController.text);

    if (newUserFee == null ||
        newMerchantFee == null ||
        newUserFee < 0 ||
        newMerchantFee < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter valid fee amounts"),
          backgroundColor: AppTheme.getErrorColor(),
        ),
      );
      return;
    }

    setState(() {
      isUpdating = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Add to history if fees changed
      if (newUserFee != userToMerchantFee) {
        feeHistory.insert(0, {
          "date": DateTime.now().toString().substring(0, 19),
          "type": "User to Merchant",
          "oldFee": userToMerchantFee,
          "newFee": newUserFee,
          "updatedBy": "Admin",
        });
        userToMerchantFee = newUserFee;
      }

      if (newMerchantFee != merchantToMerchantFee) {
        feeHistory.insert(0, {
          "date": DateTime.now().toString().substring(0, 19),
          "type": "Merchant to Merchant",
          "oldFee": merchantToMerchantFee,
          "newFee": newMerchantFee,
          "updatedBy": "Admin",
        });
        merchantToMerchantFee = newMerchantFee;
      }

      isUpdating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Transaction fees updated successfully"),
        backgroundColor: AppTheme.getSuccessColor(),
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
          Text(
            "Fee Management",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.getSuccessColor().withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.getSuccessColor(),
                            size: 6.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              "User to Merchant",
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "\$${userToMerchantFee.toStringAsFixed(2)}",
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.getSuccessColor(),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "per transaction",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'store',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 6.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              "Merchant to Merchant",
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "\$${merchantToMerchantFee.toStringAsFixed(2)}",
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "per transaction",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            "Update Transaction Fees",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _userFeeController,
                  keyboardType: TextInputType.number,
                  enabled: !isUpdating,
                  decoration: const InputDecoration(
                    labelText: "User to Merchant Fee",
                    prefixText: "\$ ",
                    suffixText: "USD",
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  controller: _merchantFeeController,
                  keyboardType: TextInputType.number,
                  enabled: !isUpdating,
                  decoration: const InputDecoration(
                    labelText: "Merchant to Merchant Fee",
                    prefixText: "\$ ",
                    suffixText: "USD",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isUpdating ? null : _updateFees,
              child: isUpdating
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        const Text("Updating..."),
                      ],
                    )
                  : const Text("Update Fees"),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Fee Change History",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feeHistory.length > 5 ? 5 : feeHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final history = feeHistory[index];
              final oldFee = history["oldFee"] as double;
              final newFee = history["newFee"] as double;
              final change = newFee - oldFee;

              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          history["type"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: change >= 0
                                ? AppTheme.getErrorColor()
                                    .withValues(alpha: 0.1)
                                : AppTheme.getSuccessColor()
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "${change >= 0 ? '+' : ''}\$${change.toStringAsFixed(2)}",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: change >= 0
                                  ? AppTheme.getErrorColor()
                                  : AppTheme.getSuccessColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${oldFee.toStringAsFixed(2)} → \$${newFee.toStringAsFixed(2)}",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          "by ${history["updatedBy"]}",
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      history["date"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
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
