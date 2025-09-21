import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';

// Import the new pages - comment out if they don't exist
// import 'package:cryptex_malawi/pages/user_dashboard.dart';
// import 'package:cryptex_malawi/pages/merchants/merchant_dashboard_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_preview_page.dart';
// import 'package:cryptex_malawi/pages/admin/admin_dashboard_page.dart';
// import 'package:cryptex_malawi/pages/merchants/escrow_management_page.dart';

// Import your existing pages (corrected paths)
import 'package:cryptex_malawi/pages/wallet/wallet_page.dart';
import 'package:cryptex_malawi/pages/wallet/recharge_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/withdraw_user_page.dart';
import 'package:cryptex_malawi/pages/wallet/transaction_history_page.dart';

class HomeDashboardPage extends StatelessWidget {
  HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Dashboard",
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: EdgeInsets.all(16),
        children: [
          NeonButton(
            label: "User Dashboard",
            onPressed: () {
              // Show placeholder or navigate if page exists
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User Dashboard - Coming Soon')),
              );
            },
          ),
          NeonButton(
            label: "Merchant Dashboard",
            onPressed: () {
              // Show placeholder or navigate if page exists
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Merchant Dashboard - Coming Soon')),
              );
            },
          ),
          NeonButton(
            label: "Transaction Preview",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TransactionPreview()),
              );
            },
          ),
          NeonButton(
            label: "Admin Dashboard",
            onPressed: () {
              // Show placeholder or navigate if page exists
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Admin Dashboard - Coming Soon')),
              );
            },
          ),
          NeonButton(
            label: "Escrow Management",
            onPressed: () {
              // Show placeholder or navigate if page exists
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Escrow Management - Coming Soon')),
              );
            },
          ),
          NeonButton(
            label: "Wallet",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WalletPage()),
              );
            },
          ),
          NeonButton(
            label: "Buy USDT",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionPreview(
                    party: 'MerchantX',
                    amountUsdt: 100,
                    amountMwk: 182000,
                    baseRate: 1800,
                    merchantRate: 1820,
                    fees: 1500,
                  ),
                ),
              );
            },
          ),
          NeonButton(
            label: "Sell USDT",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionPreview(
                    party: 'MerchantX',
                    amountUsdt: 50,
                    amountMwk: 91000,
                    baseRate: 1800,
                    merchantRate: 1790,
                    fees: 800,
                  ),
                ),
              );
            },
          ),
          NeonButton(
            label: "Recharge",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RechargePage()),
              );
            },
          ),
          NeonButton(
            label: "Withdraw",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WithdrawPage()),
              );
            },
          ),
          NeonButton(
            label: "History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TransactionHistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
