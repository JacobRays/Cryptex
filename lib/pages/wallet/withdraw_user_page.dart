import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usdtCtl = TextEditingController(text: '20');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(text: "Withdraw USDT", fontSize: 22),
          const SizedBox(height: 12),
          TextField(
            controller: usdtCtl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount USDT'),
          ),
          const SizedBox(height: 12),
          NeonButton(label: "Withdraw", onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal requested')));
          }),
        ],
      ),
    );
  }
}
