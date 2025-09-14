import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/pin_sheet.dart';

class RechargeUserPage extends StatelessWidget {
  const RechargeUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AppScaffold(
      title: "Recharge Wallet",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recharge with Airtel or Mpamba", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount in MWK"),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final pin = await showPinSheet(context);
              if (pin != null) {
                // TODO: Trigger recharge API with PIN
              }
            },
            child: const Text("Recharge"),
          ),
        ],
      ),
    );
  }
}
