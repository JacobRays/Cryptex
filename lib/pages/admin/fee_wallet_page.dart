import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class FeeWalletPage extends StatelessWidget {
  const FeeWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Fee Wallet",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Collected Fees"),
          const SizedBox(height: 12),
          const Text("USDT: \$120.00"),
          const Text("MWK: MK 140,000"),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Withdraw fees
            },
            child: const Text("Withdraw Fees"),
          ),
        ],
      ),
    );
  }
}
