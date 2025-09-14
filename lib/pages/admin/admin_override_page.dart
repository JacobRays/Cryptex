import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class AdminOverridePage extends StatelessWidget {
  const AdminOverridePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "System Override",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Force Release Escrow"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Select trade and release funds
            },
            child: const Text("Release Funds"),
          ),
          const SizedBox(height: 24),
          const Text("Suspend / Reactivate Account"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Suspend or reactivate user/merchant
            },
            child: const Text("Suspend Account"),
          ),
          const SizedBox(height: 24),
          const Text("Manual Balance Adjustment"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Adjust wallet balance
            },
            child: const Text("Adjust Balance"),
          ),
        ],
      ),
    );
  }
}
