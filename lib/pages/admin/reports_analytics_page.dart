import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class ReportsAnalyticsPage extends StatelessWidget {
  const ReportsAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Reports & Analytics",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daily Volume"),
          const SizedBox(height: 8),
          const Text("USDT: \$1,200"),
          const Text("MWK: MK 1,400,000"),
          const SizedBox(height: 24),
          const Text("Top Merchants"),
          const SizedBox(height: 8),
          const Text("1. John Crypto — 45 trades"),
          const Text("2. Zed Exchange — 38 trades"),
        ],
      ),
    );
  }
}
