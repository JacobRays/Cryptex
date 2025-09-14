import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExchangeRateWidget extends StatefulWidget {
  final double currentRate;
  final double marketRate;
  final Function(double) onRateChanged;

  const ExchangeRateWidget({
    Key? key,
    required this.currentRate,
    required this.marketRate,
    required this.onRateChanged,
  }) : super(key: key);

  @override
  State<ExchangeRateWidget> createState() => _ExchangeRateWidgetState();
}

class _ExchangeRateWidgetState extends State<ExchangeRateWidget> {
  late TextEditingController _rateController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _rateController = TextEditingController(
      text: widget.currentRate.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  double get _profitMargin {
    return ((widget.currentRate - widget.marketRate) / widget.marketRate) * 100;
  }

  Color get _marginColor {
    if (_profitMargin > 0) return AppTheme.getSuccessColor();
    if (_profitMargin < 0) return AppTheme.getErrorColor();
    return AppTheme.getWarningColor();
  }

  void _saveRate() {
    final newRate = double.tryParse(_rateController.text);
    if (newRate != null && newRate > 0) {
      widget.onRateChanged(newRate);
      setState(() {
        _isEditing = false;
      });
    }
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
                'Exchange Rate Management',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.getPrimaryColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _isEditing ? 'check' : 'edit',
                    color: AppTheme.getPrimaryColor(),
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Rate (MWK)',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    _isEditing
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.getPrimaryColor()
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            child: TextField(
                              controller: _rateController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color: AppTheme.getPrimaryColor(),
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                suffixIcon: GestureDetector(
                                  onTap: _saveRate,
                                  child: Container(
                                    margin: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.getPrimaryColor(),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      size: 4.w,
                                    ),
                                  ),
                                ),
                              ),
                              onSubmitted: (_) => _saveRate(),
                            ),
                          )
                        : Text(
                            widget.currentRate.toStringAsFixed(2),
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppTheme.getPrimaryColor(),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Rate (MWK)',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      widget.marketRate.toStringAsFixed(2),
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _marginColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _marginColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profit Margin',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${_profitMargin >= 0 ? '+' : ''}${_profitMargin.toStringAsFixed(2)}%',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _marginColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                CustomIconWidget(
                  iconName:
                      _profitMargin >= 0 ? 'trending_up' : 'trending_down',
                  color: _marginColor,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
