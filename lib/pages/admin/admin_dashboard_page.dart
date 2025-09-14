import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/neon.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Admin Dashboard",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NeonText(text: "System Overview", fontSize: 20),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NeonButton(label: "Manage Users", onPressed: () {}),
              NeonButton(label: "Manage Merchants", onPressed: () {}),
              NeonButton(label: "Fee Wallet", onPressed: () {}),
              NeonButton(label: "Global Rate", onPressed: () {}),
              NeonButton(label: "Reports", onPressed: () {}),
              NeonButton(label: "Override", onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
