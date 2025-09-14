import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class MerchantDetailsPage extends StatelessWidget {
  const MerchantDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Merchant Details",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Name: John Crypto"),
          const Text("Rating: ★★★★☆"),
          const Text("Trades Completed: 120"),
          const Text("Current Rate: MK 1,200 per USDT"),
          const SizedBox(height: 24),
          const Text("Status: Online", style: TextStyle(color: Colors.green)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Start trade with merchant
            },
            child: const Text("Buy from Merchant"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // TODO: Sell to merchant
            },
            child: const Text("Sell to Merchant"),
          ),
        ],
      ),
    );
  }
}
