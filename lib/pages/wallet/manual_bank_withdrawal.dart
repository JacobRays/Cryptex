import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class ManualBankWithdrawalPage extends StatelessWidget {
  const ManualBankWithdrawalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController bankCtl = TextEditingController();
    final TextEditingController accCtl = TextEditingController();
    final TextEditingController amtCtl = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(text: "Manual Bank Withdrawal", fontSize: 22),
          const SizedBox(height: 12),
          TextField(controller: bankCtl, decoration: const InputDecoration(labelText: 'Bank Name')),
          const SizedBox(height: 8),
          TextField(controller: accCtl, decoration: const InputDecoration(labelText: 'Account No.')),
          const SizedBox(height: 8),
          TextField(controller: amtCtl, decoration: const InputDecoration(labelText: 'Amount MWK')),
          const SizedBox(height: 12),
          NeonButton(label: "Submit", onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Manual bank withdrawal submitted')));
          }),
        ],
      ),
    );
  }
}
