import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class BuyUSDTPage extends StatelessWidget {
  const BuyUSDTPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountCtl = TextEditingController(text: '100');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(text: "Buy USDT", fontSize: 22),
          const SizedBox(height: 12),
          TextField(
            controller: amountCtl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount USDT'),
          ),
          const SizedBox(height: 12),
          NeonButton(
            label: "Buy Now",
            onPressed: () {
              final amount = double.tryParse(amountCtl.text) ?? 0;
              final mwk = amount * 1800;
              Navigator.of(context).pushNamed('/wallet/preview', arguments: {
                'party': 'MerchantX',
                'amountUsdt': amount,
                'amountMwk': mwk,
                'baseRate': 1800,
                'merchantRate': 1820,
                'fees': 1500,
              });
            },
          ),
        ],
      ),
    );
  }
}
