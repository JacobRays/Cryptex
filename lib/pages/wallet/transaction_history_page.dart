import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({Key? key}) :	super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => {
      'id': i + 1,
      'type': i % 2 == 0 ? 'BUY' : 'SELL',
      'amount': (50 + i * 5).toDouble(),
      'status': i % 3 == 0 ? 'COMPLETED' : 'PENDING',
    });
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final it = items[index];
        return NeonCard(
          padding: const EdgeInsets.all(12),
          child: ListTile(
            title: Text('${it['type']} ${it['amount']} USDT', style: const TextStyle(color: Colors.white)),
            subtitle: Text('Trade #${it['id']} • ${it['status']}', style: TextStyle(color: AppColors.textSecondary)),
          ),
        );
      },
    );
  }
}
