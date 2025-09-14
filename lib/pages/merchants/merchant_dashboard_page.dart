import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/neon.dart';

class MerchantDashboardPage extends StatelessWidget {
  const MerchantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Merchant Dashboard",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NeonText(text: "Wallet Balances", fontSize: 20),
          const SizedBox(height: 12),
          const Text("USDT: \$250.00", style: TextStyle(color: AppColors.textSecondary)),
          const Text("MWK: MK 300,000", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          const NeonText(text: "Quick Actions", fontSize: 18),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NeonButton(label: "Set Rate", onPressed: () {}),
              NeonButton(label: "Toggle Availability", onPressed: () {}),
              NeonButton(label: "Escrow", onPressed: () {}),
              NeonButton(label: "Recharge", onPressed: () {}),
              NeonButton(label: "Withdraw", onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
