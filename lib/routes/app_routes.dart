import 'package:flutter/material.dart';

// Import actual existing pages
import '../pages/home/home_dashboard_page.dart';
import '../pages/merchants/merchant_dashboard_page.dart';
import '../pages/wallet/transaction_preview_page.dart';
import '../pages/admin/admin_dashboard_page.dart';
import '../pages/wallet/wallet_page.dart';
import '../pages/wallet/transaction_history_page.dart';
import '../pages/wallet/recharge_user_page.dart';
import '../pages/wallet/withdraw_user_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String merchantDashboard = '/merchant-dashboard';
  static const String transactionPreview = '/transaction-preview';
  static const String adminDashboard = '/admin-dashboard';
  static const String wallet = '/wallet';
  static const String walletHistory = '/wallet/history';
  static const String walletRecharge = '/wallet/recharge';
  static const String walletWithdraw = '/wallet/withdraw';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => HomeDashboardPage(),
    home: (context) => HomeDashboardPage(),
    merchantDashboard: (context) => MerchantDashboard(),
    transactionPreview: (context) => TransactionPreview(),
    adminDashboard: (context) => AdminDashboard(),
    wallet: (context) => WalletPage(),
    walletHistory: (context) => TransactionHistoryPage(),
    walletRecharge: (context) => RechargeUserPage(),
    walletWithdraw: (context) => WithdrawUserPage(),
  };
}
