import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class EscrowManagementPage extends StatelessWidget {
  const EscrowManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final escrowList = [
      {"user": "Alice", "amount": "MK 50,000", "status": "Pending"},
      {"user": "Bob", "amount": "MK 30,000", "status": "Released"},
      {"user": "Charlie", "amount": "MK 20,000", "status": "Disputed"},
    ];

    return AppScaffold(
      title: "Escrow Funds",
      body: ListView.builder(
        itemCount: escrowList.length,
        itemBuilder: (context, index) {
          final tx = escrowList[index];
          final color = tx["status"] == "Released"
              ? Colors.green
              : tx["status"] == "Pending"
                  ? Colors.orange
                  : Colors.red;

          return Card(
            color: AppColors.surface,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("${tx["user"]} - ${tx["amount"]}"),
              subtitle: Text("Status: ${tx["status"]}"),
              trailing: Icon(Icons.circle, color: color, size: 12),
            ),
          );
        },
      ),
    );
  }
}
