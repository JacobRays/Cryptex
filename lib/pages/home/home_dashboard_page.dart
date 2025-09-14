import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';

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
