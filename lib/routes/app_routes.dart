import 'package:flutter/material.dart';
// Admin
import 'package:cryptex_malawi/pages/admin/admin_dashboard.dart';
import 'package:cryptex_malawi/pages/admin/global_rate_management.dart';
import 'package:cryptex_malawi/pages/admin/escrow_management.dart';
import 'package:cryptex_malawi/pages/admin/user_management.dart';
import 'package:cryptex_malawi/pages/admin/fee_wallet.dart';
import 'package:cryptex_malawi/pages/admin/admin_override.dart';
// KYC
import 'package:cryptex_malawi/pages/kyc/kyc_page.dart';
// Wallet
import 'package:cryptex_malawi/pages/wallet/wallet_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_history_page.dart';
import 'package:cryptex_malawi/pages/wallet/recharge_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_user_page.dart';
// Add your home page import
import 'package:cryptex_malawi/pages/home_page.dart'; // Adjust if needed

class AppRoutes {
  // Define initial route
  static const String initial = '/';
  
  // Define route names
  static const String home = '/';
  static const String wallet = '/wallet';
  static const String adminDashboard = '/admin';
  static const String kyc = '/kyc';
  static const String globalRateManagement = '/admin/rates';
  static const String escrowManagement = '/admin/escrow';
  static const String userManagement = '/admin/users';
  static const String feeWallet = '/admin/fees';
  static const String adminOverride = '/admin/override';
  static const String transactionHistory = '/wallet/history';
  static const String recharge = '/wallet/recharge';
  static const String withdraw = '/wallet/withdraw';
  
  // Define routes map
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => HomePage(), // Or your initial page
    wallet: (context) => WalletPage(),
    adminDashboard: (context) => AdminDashboard(),
    kyc: (context) => KYCPage(),
    globalRateManagement: (context) => GlobalRateManagement(),
    escrowManagement: (context) => EscrowManagement(),
    userManagement: (context) => UserManagement(),
    feeWallet: (context) => FeeWallet(),
    adminOverride: (context) => AdminOverride(),
    transactionHistory: (context) => TransactionHistoryPage(),
    recharge: (context) => RechargePage(),
    withdraw: (context) => WithdrawPage(),
  };
}
