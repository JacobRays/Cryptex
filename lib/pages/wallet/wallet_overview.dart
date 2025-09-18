import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class WalletOverview extends StatelessWidget {
  const WalletOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NeonText(text: "USDT Balance: \$120.00", fontSize: 20),
          const SizedBox(height: 8),
          const SizedBox(height: 24),
          Text("MWK Equivalent: MK 140,000", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NeonButton(label: "Recharge", onPressed: () {
                Navigator.of(context).pushNamed('/wallet/recharge');
              }),
              NeonButton(label: "Withdraw", onPressed: () {
                Navigator.of(context).pushNamed('/wallet/withdraw');
              }),
              NeonButton(label: "Transfer", onPressed: () {
                // Optional: navigate to transfer flow
              }),
              NeonButton(label: "History", onPressed: () {
                Navigator.of(context).pushNamed('/wallet/history');
              }),
            ],
          ),
        ],
      ),
    );
  }
}
