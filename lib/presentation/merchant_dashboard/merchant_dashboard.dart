import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_metrics_widget.dart';
import './widgets/customer_rating_widget.dart';
import './widgets/earnings_summary_widget.dart';
import './widgets/exchange_rate_widget.dart';
import './widgets/quick_settings_widget.dart';
import './widgets/status_toggle_widget.dart';
import './widgets/transaction_queue_widget.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({Key? key}) : super(key: key);

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentStatus = 'Online';

  // Mock data for merchant dashboard
  final Map<String, dynamic> _metricsData = {
    'todayTransactions': 24,
    'totalVolume': 15420.50,
    'todayEarnings': 185.75,
    'completionRate': 98.5,
  };

  final double _currentRate = 1650.00;
  final double _marketRate = 1625.00;

  final List<Map<String, dynamic>> _pendingTransactions = [
    {
      'id': 'tx_001',
      'customerName': 'John Banda',
      'type': 'buy',
      'amount': 250.0,
      'rate': 1650.0,
      'timeRemaining': 420,
    },
    {
      'id': 'tx_002',
      'customerName': 'Mary Phiri',
      'type': 'sell',
      'amount': 180.0,
      'rate': 1645.0,
      'timeRemaining': 280,
    },
    {
      'id': 'tx_003',
      'customerName': 'Peter Mwale',
      'type': 'buy',
      'amount': 500.0,
      'rate': 1650.0,
      'timeRemaining': 150,
    },
  ];

  final Map<String, dynamic> _earningsData = {
    'availableBalance': 2450.75,
    'daily': {
      'total': 185.75,
      'transactions': 24,
      'fees': 12.50,
    },
    'weekly': {
      'total': 1240.80,
      'transactions': 156,
      'fees': 78.25,
    },
    'monthly': {
      'total': 4850.60,
      'transactions': 642,
      'fees': 325.40,
    },
  };

  final Map<String, dynamic> _ratingData = {
    'averageRating': 4.7,
    'totalReviews': 128,
    'distribution': {
      '5': 89,
      '4': 28,
      '3': 8,
      '2': 2,
      '1': 1,
    },
  };

  final List<Map<String, dynamic>> _recentFeedback = [
    {
      'id': 'fb_001',
      'customerName': 'Alice Tembo',
      'rating': 5,
      'comment': 'Very fast and reliable service. Highly recommended!',
      'date': '2 hours ago',
      'hasResponse': false,
    },
    {
      'id': 'fb_002',
      'customerName': 'David Chirwa',
      'rating': 4,
      'comment': 'Good service but could be faster with confirmations.',
      'date': '1 day ago',
      'hasResponse': true,
    },
    {
      'id': 'fb_003',
      'customerName': 'Grace Nyirenda',
      'rating': 5,
      'comment': 'Excellent rates and professional service.',
      'date': '3 days ago',
      'hasResponse': false,
    },
  ];

  final Map<String, dynamic> _settingsData = {
    'autoApproval': true,
    'pushNotifications': true,
    'autoApprovalThreshold': 100.0,
    'schedule': 'Mon-Fri 8AM-6PM',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onStatusChanged(String newStatus) {
    setState(() {
      _currentStatus = newStatus;
    });
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to $newStatus'),
        backgroundColor: AppTheme.getSuccessColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onRateChanged(double newRate) {
    // Handle rate change
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Exchange rate updated to MWK ${newRate.toStringAsFixed(2)}'),
        backgroundColor: AppTheme.getPrimaryColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onTransactionAction(String transactionId, String action) {
    setState(() {
      _pendingTransactions.removeWhere((tx) => tx['id'] == transactionId);
    });

    final actionText = action == 'approve' ? 'approved' : 'rejected';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction $actionText successfully'),
        backgroundColor: action == 'approve'
            ? AppTheme.getSuccessColor()
            : AppTheme.getErrorColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onWithdraw(String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Withdrawal request submitted via $method'),
        backgroundColor: AppTheme.getSuccessColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onRespondToFeedback(String feedbackId, String customerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Response sent to $customerName'),
        backgroundColor: AppTheme.getPrimaryColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSettingChanged(String key, dynamic value) {
    setState(() {
      _settingsData[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Setting updated successfully'),
        backgroundColor: AppTheme.getPrimaryColor(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'store',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Merchant Dashboard',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.getPrimaryColor(),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.getPrimaryColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.getPrimaryColor(),
                size: 5.w,
              ),
              text: 'Dashboard',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'swap_horiz',
                color: AppTheme.getPrimaryColor(),
                size: 5.w,
              ),
              text: 'Transactions',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.getPrimaryColor(),
                size: 5.w,
              ),
              text: 'Earnings',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.getPrimaryColor(),
                size: 5.w,
              ),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildTransactionsTab(),
          _buildEarningsTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Merchant Dashboard is active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/login-screen');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/user-dashboard');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/admin-dashboard');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'login',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'login',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'store',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
            label: 'Merchant',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'admin_panel_settings',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'admin_panel_settings',
              color: AppTheme.getPrimaryColor(),
              size: 6.w,
            ),
            label: 'Admin',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusToggleWidget(
            currentStatus: _currentStatus,
            onStatusChanged: _onStatusChanged,
          ),
          SizedBox(height: 4.h),
          BusinessMetricsWidget(
            metricsData: _metricsData,
          ),
          SizedBox(height: 4.h),
          ExchangeRateWidget(
            currentRate: _currentRate,
            marketRate: _marketRate,
            onRateChanged: _onRateChanged,
          ),
          SizedBox(height: 4.h),
          TransactionQueueWidget(
            pendingTransactions: _pendingTransactions,
            onTransactionAction: _onTransactionAction,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Management',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.getPrimaryColor(),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          TransactionQueueWidget(
            pendingTransactions: _pendingTransactions,
            onTransactionAction: _onTransactionAction,
          ),
          SizedBox(height: 4.h),
          CustomerRatingWidget(
            ratingData: _ratingData,
            recentFeedback: _recentFeedback,
            onRespondToFeedback: _onRespondToFeedback,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings Overview',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.getPrimaryColor(),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          EarningsSummaryWidget(
            earningsData: _earningsData,
            onWithdraw: _onWithdraw,
          ),
          SizedBox(height: 4.h),
          BusinessMetricsWidget(
            metricsData: _metricsData,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merchant Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.getPrimaryColor(),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          QuickSettingsWidget(
            settingsData: _settingsData,
            onSettingChanged: _onSettingChanged,
          ),
          SizedBox(height: 4.h),
          ExchangeRateWidget(
            currentRate: _currentRate,
            marketRate: _marketRate,
            onRateChanged: _onRateChanged,
          ),
        ],
      ),
    );
  }
}
