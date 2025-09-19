import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class RechargePage extends StatelessWidget {
  const RechargePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController mwkCtl = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(text: "Recharge MWK", fontSize: 22),
          const SizedBox(height: 12),
          TextField(
            controller: mwkCtl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount MWK'),
          ),
          const SizedBox(height: 12),
          NeonButton(label: "Recharge", onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recharge request submitted')));
          }),
        ],
      ),
    );
  }
}
