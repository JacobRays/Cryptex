import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/exchange_rate_ticker_widget.dart';
import './widgets/merchant_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/transaction_item_widget.dart';
import './widgets/wallet_card_widget.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data for wallet balances
  final List<Map<String, dynamic>> walletData = [
    {
      "currency": "USDT",
      "balance": "1,250.50",
      "equivalent": "≈ \$1,250.50 USD",
    },
    {
      "currency": "Kwacha",
      "balance": "2,875,000.00",
      "equivalent": "≈ 1,250.50 USDT",
    },
  ];

  // Mock data for exchange rate
  final Map<String, dynamic> exchangeRateData = {
    "rate": "2,300.00",
    "changePercentage": "2.5",
    "isPositive": true,
  };

  // Mock data for merchants
  final List<Map<String, dynamic>> merchantsData = [
    {
      "name": "CryptoTrader MW",
      "exchangeRate": "2,305.00",
      "rating": 4.8,
      "responseTime": "2 min",
      "status": "online",
    },
    {
      "name": "FastExchange",
      "exchangeRate": "2,298.50",
      "rating": 4.6,
      "responseTime": "5 min",
      "status": "busy",
    },
    {
      "name": "SecureSwap",
      "exchangeRate": "2,310.00",
      "rating": 4.9,
      "responseTime": "1 min",
      "status": "online",
    },
    {
      "name": "QuickTrade",
      "exchangeRate": "2,295.00",
      "rating": 4.4,
      "responseTime": "10 min",
      "status": "offline",
    },
  ];

  // Mock data for recent transactions
  final List<Map<String, dynamic>> transactionsData = [
    {
      "type": "Buy",
      "amount": "+500.00 USDT",
      "currency": "USDT",
      "status": "Completed",
      "date": "11 Sep 2025, 10:30 AM",
      "merchantName": "CryptoTrader MW",
    },
    {
      "type": "Sell",
      "amount": "-200.00 USDT",
      "currency": "USDT",
      "status": "Pending",
      "date": "10 Sep 2025, 3:45 PM",
      "merchantName": "FastExchange",
    },
    {
      "type": "Withdraw",
      "amount": "-1,000,000.00 MWK",
      "currency": "MWK",
      "status": "Completed",
      "date": "09 Sep 2025, 11:20 AM",
      "merchantName": "Airtel Money",
    },
  ];

  Future<void> _refreshData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would fetch fresh data from APIs
    setState(() {
      // Data would be updated here
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _showWalletActions(String currencyType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    '$currencyType Wallet Actions',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton('Recharge', 'add_circle', () {}),
                      _buildActionButton('Withdraw', 'remove_circle', () {}),
                      _buildActionButton('History', 'history', () {}),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 7.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'security',
              color: AppTheme.getSuccessColor(),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Cryptex Malawi',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // QR Scanner functionality
            },
            icon: CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () {
              // Notifications
            },
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Cards Section
              SizedBox(
                height: 22.h,
                child: PageView.builder(
                  itemCount: walletData.length,
                  itemBuilder: (context, index) {
                    final wallet = walletData[index];
                    return WalletCardWidget(
                      currencyType: wallet["currency"] as String,
                      balance: wallet["balance"] as String,
                      equivalent: wallet["equivalent"] as String,
                      onTap: () {
                        // Handle wallet tap
                      },
                      onLongPress: () {
                        _showWalletActions(wallet["currency"] as String);
                      },
                    );
                  },
                ),
              ),

              // Exchange Rate Ticker
              ExchangeRateTickerWidget(
                rate: exchangeRateData["rate"] as String,
                changePercentage:
                    exchangeRateData["changePercentage"] as String,
                isPositive: exchangeRateData["isPositive"] as bool,
              ),

              // Quick Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuickActionButtonWidget(
                      title: 'Buy USDT',
                      iconName: 'arrow_downward',
                      isPrimary: true,
                      onPressed: () {
                        Navigator.pushNamed(context, '/buy-usdt-screen');
                      },
                    ),
                    QuickActionButtonWidget(
                      title: 'Sell USDT',
                      iconName: 'arrow_upward',
                      onPressed: () {
                        Navigator.pushNamed(context, '/sell-usdt-screen');
                      },
                    ),
                  ],
                ),
              ),

              // Merchant Availability Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Text(
                  'Available Merchants',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: merchantsData.length,
                  itemBuilder: (context, index) {
                    final merchant =
                        merchantsData[index];
                    return MerchantCardWidget(
                      merchantName: merchant["name"] as String,
                      exchangeRate: merchant["exchangeRate"] as String,
                      rating: merchant["rating"] as double,
                      responseTime: merchant["responseTime"] as String,
                      status: merchant["status"] as String,
                      onTap: () {
                        // Handle merchant selection
                      },
                    );
                  },
                ),
              ),

              // Recent Transactions Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to full transaction history
                      },
                      child: Text(
                        'View All',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionsData.length,
                itemBuilder: (context, index) {
                  final transaction =
                      transactionsData[index];
                  return TransactionItemWidget(
                    type: transaction["type"] as String,
                    amount: transaction["amount"] as String,
                    currency: transaction["currency"] as String,
                    status: transaction["status"] as String,
                    date: transaction["date"] as String,
                    merchantName: transaction["merchantName"] as String,
                    onTap: () {
                      // Handle transaction details view
                    },
                  );
                },
              ),
              SizedBox(height: 10.h), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // QR Scanner for peer transactions
        },
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'qr_code_scanner',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _selectedTabIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'receipt_long',
              color: _selectedTabIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'account_balance_wallet',
              color: _selectedTabIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedTabIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
