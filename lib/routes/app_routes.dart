import 'package:flutter/material.dart';

// Only import the essential pages that we know work
import 'package:cryptex_malawi/pages/wallet/wallet_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_history_page.dart';
import 'package:cryptex_malawi/pages/wallet/recharge_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_preview_page.dart';
import 'package:cryptex_malawi/pages/user_dashboard.dart';

class AppRoutes {
  // Define initial route
  static const String initial = '/';
  
  // Essential routes only
  static const String home = '/';
  static const String wallet = '/wallet';
  static const String userDashboard = '/user-dashboard';
  static const String transactionHistory = '/wallet/history';
  static const String recharge = '/wallet/recharge';
  static const String withdraw = '/wallet/withdraw';
  static const String transactionPreview = '/wallet/preview';
  
  // Define routes map - minimal working set
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => UserDashboard(), // Use UserDashboard as main page
    home: (context) => UserDashboard(),
    userDashboard: (context) => UserDashboard(),
    wallet: (context) => WalletPage(),
    transactionHistory: (context) => TransactionHistoryPage(),
    recharge: (context) => RechargePage(),
    withdraw: (context) => WithdrawPage(),
    transactionPreview: (context) => TransactionPreview(),
  };
}
