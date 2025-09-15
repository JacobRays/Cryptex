import 'package:flutter/material.dart';

// Import actual existing pages
import '../pages/home/home_dashboard_page.dart';
import '../pages/merchants/merchant_dashboard_page.dart';
import '../pages/transactions/transaction_preview.dart';
import '../pages/admin/admin_dashboard.dart';
import '../pages/wallet/wallet_page.dart';
import '../pages/wallet/transaction_history_page.dart';
import '../pages/wallet/recharge_user_page.dart';
import '../pages/wallet/withdraw_user_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  // ... other route names

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => HomeDashboardPage(),
    home: (context) => HomeDashboardPage(),
    '/merchant-dashboard': (context) => MerchantDashboard(),
    '/transaction-preview': (context) => TransactionPreview(),
    '/admin-dashboard': (context) => AdminDashboard(),
    '/wallet': (context) => WalletPage(),
    '/wallet/history': (context) => TransactionHistoryPage(),
    '/wallet/recharge': (context) => RechargeUserPage(),
    '/wallet/withdraw': (context) => WithdrawUserPage(),
  };
}

