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
          // You can keep your original buttons too if needed
          NeonButton(label: "Wallet", onPressed: () {}),
          NeonButton(label: "Buy USDT", onPressed: () {}),
          NeonButton(label: "Sell USDT", onPressed: () {}),
          NeonButton(label: "Recharge", onPressed: () {}),
          NeonButton(label: "Withdraw", onPressed: () {}),
          NeonButton(label: "History", onPressed: () {}),
        ],
      ),
    );
  }
}
