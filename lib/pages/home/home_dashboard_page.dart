import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';

// Import the new pages
import 'package:cryptex_malawi/pages/user_dashboard.dart';
import 'package:cryptex_malawi/pages/merchants/merchant_dashboard.dart';
import 'package:cryptex_malawi/pages/transactions/transaction_preview.dart';
import 'package:cryptex_malawi/pages/admin/admin_dashboard.dart';
import 'package:cryptex_malawi/pages/merchants/escrow_management_page.dart';

// Import your existing pages
import 'package:cryptex_malawi/pages/wallet_page.dart';
import 'package:cryptex_malawi/pages/buy_usdt_page.dart';
import 'package:cryptex_malawi/pages/sell_usdt_page.dart';
import 'package:cryptex_malawi/pages/recharge_page.dart';
import 'package:cryptex_malawi/pages/withdraw_page.dart';
import 'package:cryptex_malawi/pages/transaction_history_page.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Dashboard",
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          NeonButton(
            label: "User Dashboard",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserDashboard()),
              );
            },
          ),
          NeonButton(
            label: "Merchant Dashboard",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MerchantDashboard()),
              );
            },
          ),
          NeonButton(
            label: "Transaction Preview",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionPreview()),
              );
            },
          ),
          NeonButton(
            label: "Admin Dashboard",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboard()),
              );
            },
          ),
          NeonButton(
            label: "Escrow Management",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EscrowManagementPage()),
              );
            },
          ),
          NeonButton(
            label: "Wallet",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletPage()),
              );
            },
          ),
          NeonButton(
            label: "Buy USDT",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuyUsdtPage()),
              );
            },
          ),
          NeonButton(
            label: "Sell USDT",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SellUsdtPage()),
              );
            },
          ),
          NeonButton(
            label: "Recharge",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RechargePage()),
              );
            },
          ),
          NeonButton(
            label: "Withdraw",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WithdrawPage()),
              );
            },
          ),
          NeonButton(
            label: "History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionHistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
