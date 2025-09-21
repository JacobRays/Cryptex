import 'package:flutter/material.dart';

// Main pages
import 'package:cryptex_malawi/pages/home_dashboard_page.dart';
import 'package:cryptex_malawi/pages/splash_page.dart';
import 'package:cryptex_malawi/pages/onboarding_page.dart';
import 'package:cryptex_malawi/pages/user_dashboard.dart';

// Auth pages
import 'package:cryptex_malawi/pages/auth/login_page.dart';
import 'package:cryptex_malawi/pages/auth/register_page.dart';

// Wallet pages
import 'package:cryptex_malawi/pages/wallet/wallet_page.dart';
import 'package:cryptex_malawi/pages/wallet/wallet_overview.dart';
import 'package:cryptex_malawi/pages/wallet/buy_usdt.dart';
import 'package:cryptex_malawi/pages/wallet/sell_usdt.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_history_page.dart';
import 'package:cryptex_malawi/pages/wallet/recharge_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_preview_page.dart';
import 'package:cryptex_malawi/pages/wallet/confirm_transaction_page.dart';
import 'package:cryptex_malawi/pages/wallet/manual_bank_withdrawal.dart';

// Admin pages
import 'package:cryptex_malawi/pages/admin/admin_dashboard_page.dart';
import 'package:cryptex_malawi/pages/admin/admin_override_page.dart';
import 'package:cryptex_malawi/pages/admin/fee_wallet_page.dart';
import 'package:cryptex_malawi/pages/admin/global_rate_management_page.dart';
import 'package:cryptex_malawi/pages/admin/reports_analytics_page.dart';
import 'package:cryptex_malawi/pages/admin/user_merchant_management_page.dart';

// Merchant pages
import 'package:cryptex_malawi/pages/merchants/merchant_dashboard_page.dart';
import 'package:cryptex_malawi/pages/merchants/merchant_details_page.dart';
import 'package:cryptex_malawi/pages/merchants/merchant_availability_toggle_page.dart';
import 'package:cryptex_malawi/pages/merchants/escrow_management_page.dart';

// KYC pages
import 'package:cryptex_malawi/pages/kyc/kyc_page.dart';

// Security pages
import 'package:cryptex_malawi/pages/security/secure_pin_verification_page.dart';

// Other pages
import 'package:cryptex_malawi/pages/notifications_page.dart';
import 'package:cryptex_malawi/pages/support_page.dart';
import 'package:cryptex_malawi/pages/error/error_page.dart';
import 'package:cryptex_malawi/pages/error/no_connection_page.dart';

class AppRoutes {
  // Define initial route
  static const String initial = '/splash';
  
  // Main routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String userDashboard = '/user-dashboard';
  
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  
  // Wallet routes
  static const String wallet = '/wallet';
  static const String walletOverview = '/wallet/overview';
  static const String buyUsdt = '/wallet/buy';
  static const String sellUsdt = '/wallet/sell';
  static const String transactionHistory = '/wallet/history';
  static const String recharge = '/wallet/recharge';
  static const String withdraw = '/wallet/withdraw';
  static const String transactionPreview = '/wallet/preview';
  static const String confirmTransaction = '/wallet/confirm';
  static const String manualBankWithdrawal = '/wallet/manual-bank';
  
  // Admin routes
  static const String adminDashboard = '/admin';
  static const String adminOverride = '/admin/override';
  static const String feeWallet = '/admin/fee-wallet';
  static const String globalRateManagement = '/admin/rates';
  static const String reportsAnalytics = '/admin/reports';
  static const String userMerchantManagement = '/admin/users';
  
  // Merchant routes
  static const String merchantDashboard = '/merchant';
  static const String merchantDetails = '/merchant/details';
  static const String merchantAvailability = '/merchant/availability';
  static const String escrowManagement = '/merchant/escrow';
  
  // KYC routes
  static const String kyc = '/kyc';
  
  // Security routes
  static const String pinVerification = '/security/pin';
  
  // Other routes
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String error = '/error';
  static const String noConnection = '/no-connection';
  
  // Define routes map
  static Map<String, WidgetBuilder> routes = {
    // Main routes
    splash: (context) => SplashPage(),
    onboarding: (context) => OnboardingPage(),
    home: (context) => HomeDashboardPage(),
    dashboard: (context) => HomeDashboardPage(),
    userDashboard: (context) => UserDashboard(),
    
    // Auth routes
    login: (context) => LoginPage(),
    register: (context) => RegisterPage(),
    
    // Wallet routes
    wallet: (context) => WalletPage(),
    walletOverview: (context) => WalletOverview(),
    buyUsdt: (context) => BuyUSDTPage(),
    sellUsdt: (context) => SellUSDTPage(),
    transactionHistory: (context) => TransactionHistoryPage(),
    recharge: (context) => RechargePage(),
    withdraw: (context) => WithdrawPage(),
    transactionPreview: (context) => TransactionPreview(),
    confirmTransaction: (context) => ConfirmTransactionPage(),
    manualBankWithdrawal: (context) => ManualBankWithdrawalPage(),
    
    // Admin routes
    adminDashboard: (context) => AdminDashboard(),
    adminOverride: (context) => AdminOverridePage(),
    feeWallet: (context) => FeeWalletPage(),
    globalRateManagement: (context) => GlobalRateManagementPage(),
    reportsAnalytics: (context) => ReportsAnalyticsPage(),
    userMerchantManagement: (context) => UserMerchantManagementPage(),
    
    // Merchant routes
    merchantDashboard: (context) => MerchantDashboard(),
    merchantDetails: (context) => MerchantDetailsPage(),
    merchantAvailability: (context) => MerchantAvailabilityTogglePage(),
    escrowManagement: (context) => EscrowManagementPage(),
    
    // KYC routes
    kyc: (context) => KYCPage(),
    
    // Security routes
    pinVerification: (context) => SecurePinVerificationPage(),
    
    // Other routes
    notifications: (context) => NotificationsPage(),
    support: (context) => SupportPage(),
    error: (context) => ErrorPage(),
    noConnection: (context) => NoConnectionPage(),
  };
}
