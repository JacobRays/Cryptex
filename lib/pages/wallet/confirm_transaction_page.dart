import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/pin_sheet.dart';

class ConfirmTransactionPage extends StatelessWidget {
  const ConfirmTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Confirm Transaction",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Merchant: John Crypto"),
          const SizedBox(height: 8),
          const Text("Amount: MK 50,000"),
          const SizedBox(height: 8),
          const Text("Rate: MK 1,200 per USDT"),
          const SizedBox(height: 8),
          const Text("Fee: MK 500"),
          const SizedBox(height: 8),
          const Text("Total: MK 50,500"),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final pin = await showPinSheet(context);
                    if (pin != null) {
                      // TODO: Confirm transaction with PIN
                    }
                  },
                  child: const Text("SEND"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
