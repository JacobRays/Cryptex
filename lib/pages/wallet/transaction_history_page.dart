import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {"type": "Buy", "amount": "50 USDT", "status": "Completed"},
      {"type": "Withdraw", "amount": "MK 40,000", "status": "Pending"},
      {"type": "Recharge", "amount": "MK 20,000", "status": "Completed"},
    ];

    return AppScaffold(
      title: "Transaction History",
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final color = tx["status"] == "Completed"
              ? Colors.green
              : tx["status"] == "Pending"
                  ? Colors.orange
                  : Colors.red;

          return Card(
            color: AppColors.surface,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("${tx["type"]} - ${tx["amount"]}"),
              subtitle: Text("Status: ${tx["status"]}"),
              trailing: Icon(Icons.circle, color: color, size: 12),
            ),
          );
        },
      ),
    );
  }
}
