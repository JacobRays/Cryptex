import 'package:flutter/material.dart';
import '../pages/splash_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_dashboard_page.dart';
import '../pages/wallet/wallet_page.dart';
import '../pages/wallet/transaction_history_page.dart';
import '../pages/wallet/recharge_user_page.dart';
import '../pages/wallet/withdraw_user_page.dart';
import '../pages/wallet/confirm_transaction_page.dart';
import '../pages/merchants/merchant_dashboard_page.dart';
import '../pages/merchants/merchant_details_page.dart';
import '../pages/merchants/merchant_availability_toggle_page.dart';
import '../pages/merchants/escrow_management_page.dart';
import '../pages/admin/admin_dashboard_page.dart';
import '../pages/admin/admin_override_page.dart';
import '../pages/admin/fee_wallet_page.dart';
import '../pages/admin/global_rate_management_page.dart';
import '../pages/admin/user_merchant_management_page.dart';
import '../pages/admin/reports_analytics_page.dart';
import '../pages/settings_page.dart';
import '../pages/support_page.dart';
import '../pages/notifications_page.dart';
import '../pages/system/error_page.dart';
import '../pages/system/no_connection_page.dart';
import '../pages/system/secure_pin_verification_page.dart';
import '../pages/airtel_mpamba_integration_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashPage(),
    '/onboarding': (context) => const OnboardingPage(),
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomeDashboardPage(),
    '/wallet': (context) => const WalletPage(),
    '/wallet/history': (context) => const TransactionHistoryPage(),
    '/wallet/recharge': (context) => const RechargeUserPage(),
    '/wallet/withdraw': (context) => const WithdrawUserPage(),
    '/wallet/confirm': (context) => const ConfirmTransactionPage(),
    '/merchant/dashboard': (context) => const MerchantDashboardPage(),
    '/merchant/details': (context) => const MerchantDetailsPage(),
    '/merchant/availability': (context) => const MerchantAvailabilityTogglePage(),
    '/merchant/escrow': (context) => const EscrowManagementPage(),
    '/admin/dashboard': (context) => const AdminDashboardPage(),
    '/admin/override': (context) => const AdminOverridePage(),
    '/admin/fees': (context) => const FeeWalletPage(),
    '/admin/rates': (context) => const GlobalRateManagementPage(),
    '/admin/manage': (context) => const UserMerchantManagementPage(),
    '/admin/reports': (context) => const ReportsAnalyticsPage(),
    '/settings': (context) => const SettingsPage(),
    '/support': (context) => const SupportPage(),
    '/notifications': (context) => const NotificationsPage(),
    '/error': (context) => const ErrorPage(),
    '/offline': (context) => const NoConnectionPage(),
    '/pin': (context) => const SecurePINVerificationPage(),
    '/integration': (context) => const AirtelMpambaIntegrationPage(),
  };
}
