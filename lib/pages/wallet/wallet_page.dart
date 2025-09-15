import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';

class WalletPage extends StatelessWidget {
  WalletPage({super.key}); // removed const here to avoid const constructor issues

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "My Wallet",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NeonText(text: "USDT Balance: \$120.00", fontSize: 20),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          // No const here because AppColors.textSecondary is not a compile-time constant
          Text(
            "MWK Equivalent: MK 140,000",
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NeonButton(label: "Recharge", onPressed: () {}),
              NeonButton(label: "Withdraw", onPressed: () {}),
              NeonButton(label: "Transfer", onPressed: () {}),
              NeonButton(label: "History", onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
