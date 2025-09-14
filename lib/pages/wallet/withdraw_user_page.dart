import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/pin_sheet.dart';

class WithdrawUserPage extends StatelessWidget {
  const WithdrawUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AppScaffold(
      title: "Withdraw USDT",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Withdraw to external USDT wallet", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "USDT Wallet Address"),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount in USDT"),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              final pin = await showPinSheet(context);
              if (pin != null) {
                // TODO: Trigger withdrawal API with PIN
              }
            },
            child: const Text("Withdraw"),
          ),
        ],
      ),
    );
  }
}
