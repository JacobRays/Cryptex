import 'package:flutter/material.dart';

// Auth screens
import 'package:cryptex_malawi/presentation/login_screen/login_screen.dart';

// Main dashboard
import 'package:cryptex_malawi/pages/main_dashboard.dart';

// Existing pages
import 'package:cryptex_malawi/pages/user_dashboard.dart';
import 'package:cryptex_malawi/pages/wallet/wallet_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_history_page.dart';
import 'package:cryptex_malawi/pages/wallet/recharge_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_preview_page.dart';

class AppRoutes {
  // Define initial route
  static const String initial = '/login';
  
  // Auth routes
  static const String login = '/login';
  
  // Dashboard routes - all point to MainDashboard for now
  static const String adminDashboard = '/admin-dashboard';
  static const String merchantDashboard = '/merchant-dashboard';
  static const String userDashboard = '/user-dashboard';
  
  // Main routes
  static const String home = '/home';
  static const String mainDashboard = '/main-dashboard';
  
  // Wallet routes
  static const String wallet = '/wallet';
  static const String transactionHistory = '/wallet/history';
  static const String recharge = '/wallet/recharge';
  static const String withdraw = '/wallet/withdraw';
  static const String transactionPreview = '/wallet/preview';
  
  // Define routes map
  static Map<String, WidgetBuilder> routes = {
    // Auth
    login: (context) => LoginScreen(),
    
    // All dashboard routes point to MainDashboard
    adminDashboard: (context) => MainDashboard(),
    merchantDashboard: (context) => MainDashboard(),
    userDashboard: (context) => MainDashboard(),
    mainDashboard: (context) => MainDashboard(),
    home: (context) => MainDashboard(),
    
    // Wallet pages
    wallet: (context) => WalletPage(),
    transactionHistory: (context) => TransactionHistoryPage(),
    recharge: (context) => RechargePage(),
    withdraw: (context) => WithdrawPage(),
    transactionPreview: (context) => TransactionPreview(),
  };
}
