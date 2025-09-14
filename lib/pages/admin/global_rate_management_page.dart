import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class GlobalRateManagementPage extends StatelessWidget {
  const GlobalRateManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AppScaffold(
      title: "Global Rate Management",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Rate: MK 1,200 per USDT"),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "New Rate"),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Update global rate
            },
            child: const Text("Update Rate"),
          ),
        ],
      ),
    );
  }
}
