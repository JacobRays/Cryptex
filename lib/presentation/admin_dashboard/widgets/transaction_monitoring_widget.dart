import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TransactionMonitoringWidget extends StatefulWidget {
  const TransactionMonitoringWidget({super.key});

  @override
  State<TransactionMonitoringWidget> createState() =>
      _TransactionMonitoringWidgetState();
}

class _TransactionMonitoringWidgetState
    extends State<TransactionMonitoringWidget> {
  String selectedFilter = "All";
  final List<String> filterOptions = [
    "All",
    "Pending",
    "Completed",
    "Disputed",
    "Failed"
  ];

  final List<Map<String, dynamic>> transactionsData = [
    {
      "id": "TXN001",
      "type": "Buy USDT",
      "amount": "500.00 USDT",
      "value": "MWK 850,000",
      "user": "Chisomo Banda",
      "merchant": "Blessings Forex",
      "status": "Completed",
      "timestamp": "2025-01-11 12:45:23",
      "fee": "\$0.50",
      "method": "Airtel Money",
    },
    {
      "id": "TXN002",
      "type": "Sell USDT",
      "amount": "250.00 USDT",
      "value": "MWK 425,000",
      "user": "Mphatso Mwale",
      "merchant": "Malawi Crypto Hub",
      "status": "Pending",
      "timestamp": "2025-01-11 12:32:15",
      "fee": "\$0.50",
      "method": "Mpamba",
    },
    {
      "id": "TXN003",
      "type": "Buy USDT",
      "amount": "1000.00 USDT",
      "value": "MWK 1,700,000",
      "user": "Thandiwe Phiri",
      "merchant": "Lilongwe Exchange",
      "status": "Disputed",
      "timestamp": "2025-01-11 11:58:42",
      "fee": "\$0.50",
      "method": "Bank Transfer",
    },
    {
      "id": "TXN004",
      "type": "Sell USDT",
      "amount": "150.00 USDT",
      "value": "MWK 255,000",
      "user": "Kondwani Nyirenda",
      "merchant": "Blantyre Traders",
      "status": "Failed",
      "timestamp": "2025-01-11 11:23:17",
      "fee": "\$0.50",
      "method": "Airtel Money",
    },
    {
      "id": "TXN005",
      "type": "Buy USDT",
      "amount": "750.00 USDT",
      "value": "MWK 1,275,000",
      "user": "Grace Tembo",
      "merchant": "Blessings Forex",
      "status": "Completed",
      "timestamp": "2025-01-11 10:45:33",
      "fee": "\$0.50",
      "method": "Mpamba",
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == "All") {
      return transactionsData;
    }
    return transactionsData
        .where((transaction) =>
            (transaction["status"] as String).toLowerCase() ==
            selectedFilter.toLowerCase())
        .toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.getSuccessColor();
      case 'pending':
        return AppTheme.getWarningColor();
      case 'disputed':
        return AppTheme.getErrorColor();
      case 'failed':
        return AppTheme.getErrorColor();
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _handleTransaction(String transactionId, String action) {
    setState(() {
      final transactionIndex =
          transactionsData.indexWhere((tx) => tx["id"] == transactionId);
      if (transactionIndex != -1) {
        switch (action) {
          case 'approve':
            transactionsData[transactionIndex]["status"] = "Completed";
            break;
          case 'reject':
            transactionsData[transactionIndex]["status"] = "Failed";
            break;
          case 'investigate':
            transactionsData[transactionIndex]["status"] = "Under Review";
            break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Transaction $transactionId ${action}d successfully"),
        backgroundColor: action == 'approve'
            ? AppTheme.getSuccessColor()
            : action == 'reject'
                ? AppTheme.getErrorColor()
                : AppTheme.getWarningColor(),
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
                "Transaction Monitoring",
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
                  "Live Feed",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((filter) {
                final isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => selectedFilter = filter),
                  child: Container(
                    margin: EdgeInsets.only(right: 2.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.2)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      filter,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredTransactions.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final transaction = filteredTransactions[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction["id"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(transaction["status"] as String)
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            transaction["status"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getStatusColor(
                                  transaction["status"] as String),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction["type"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              transaction["amount"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              transaction["value"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Fee: ${transaction["fee"]}",
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "User: ${transaction["user"]}",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            "Merchant: ${transaction["merchant"]}",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction["method"] as String,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          transaction["timestamp"] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if ((transaction["status"] as String).toLowerCase() ==
                            "pending" ||
                        (transaction["status"] as String).toLowerCase() ==
                            "disputed") ...[
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _handleTransaction(
                                  transaction["id"] as String, "approve"),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.getSuccessColor()
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.getSuccessColor()
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  "Approve",
                                  textAlign: TextAlign.center,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.getSuccessColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _handleTransaction(
                                  transaction["id"] as String, "reject"),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.getErrorColor()
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.getErrorColor()
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  "Reject",
                                  textAlign: TextAlign.center,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.getErrorColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _handleTransaction(
                                  transaction["id"] as String, "investigate"),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.getWarningColor()
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.getWarningColor()
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  "Review",
                                  textAlign: TextAlign.center,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.getWarningColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
