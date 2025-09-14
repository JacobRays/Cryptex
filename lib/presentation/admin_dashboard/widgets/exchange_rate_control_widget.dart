import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExchangeRateControlWidget extends StatefulWidget {
  const ExchangeRateControlWidget({super.key});

  @override
  State<ExchangeRateControlWidget> createState() =>
      _ExchangeRateControlWidgetState();
}

class _ExchangeRateControlWidgetState extends State<ExchangeRateControlWidget> {
  final TextEditingController _rateController = TextEditingController();
  double currentRate = 1700.00;
  double previousRate = 1685.50;
  bool isUpdating = false;

  final List<Map<String, dynamic>> rateHistory = [
    {
      "date": "2025-01-11 12:00:00",
      "rate": 1700.00,
      "change": "+14.50",
      "updatedBy": "Admin",
    },
    {
      "date": "2025-01-10 15:30:00",
      "rate": 1685.50,
      "change": "-8.25",
      "updatedBy": "System",
    },
    {
      "date": "2025-01-10 09:15:00",
      "rate": 1693.75,
      "change": "+22.10",
      "updatedBy": "Admin",
    },
    {
      "date": "2025-01-09 14:45:00",
      "rate": 1671.65,
      "change": "-5.80",
      "updatedBy": "System",
    },
  ];

  @override
  void initState() {
    super.initState();
    _rateController.text = currentRate.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  void _updateExchangeRate() async {
    if (_rateController.text.isEmpty) return;

    final newRate = double.tryParse(_rateController.text);
    if (newRate == null || newRate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a valid exchange rate"),
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
      previousRate = currentRate;
      currentRate = newRate;
      isUpdating = false;

      // Add to history
      rateHistory.insert(0, {
        "date": DateTime.now().toString().substring(0, 19),
        "rate": newRate,
        "change": (newRate - previousRate).toStringAsFixed(2),
        "updatedBy": "Admin",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Exchange rate updated to MWK ${newRate.toStringAsFixed(2)}"),
        backgroundColor: AppTheme.getSuccessColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rateChange = currentRate - previousRate;
    final changePercentage = ((rateChange / previousRate) * 100);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Exchange Rate Control",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
                      "Current Rate",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: rateChange >= 0
                            ? AppTheme.getSuccessColor().withValues(alpha: 0.1)
                            : AppTheme.getErrorColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: rateChange >= 0
                                ? 'trending_up'
                                : 'trending_down',
                            color: rateChange >= 0
                                ? AppTheme.getSuccessColor()
                                : AppTheme.getErrorColor(),
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "${changePercentage >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(2)}%",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: rateChange >= 0
                                  ? AppTheme.getSuccessColor()
                                  : AppTheme.getErrorColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  "1 USDT = MWK ${currentRate.toStringAsFixed(2)}",
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Previous: MWK ${previousRate.toStringAsFixed(2)}",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Update Exchange Rate",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "New Rate (MWK)",
                    prefixText: "MWK ",
                    suffixText: "per USDT",
                    enabled: !isUpdating,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: isUpdating ? null : _updateExchangeRate,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isUpdating
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isUpdating
                      ? SizedBox(
                          width: 6.w,
                          height: 6.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'update',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 6.w,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            "Rate History",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rateHistory.length > 5 ? 5 : rateHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final history = rateHistory[index];
              final change = double.parse(history["change"] as String);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MWK ${(history["rate"] as double).toStringAsFixed(2)}",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            history["date"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: change >= 0
                                ? AppTheme.getSuccessColor()
                                    .withValues(alpha: 0.1)
                                : AppTheme.getErrorColor()
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: change >= 0
                                  ? AppTheme.getSuccessColor()
                                  : AppTheme.getErrorColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
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
