import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class MerchantAvailabilityTogglePage extends StatefulWidget {
  const MerchantAvailabilityTogglePage({super.key});

  @override
  State<MerchantAvailabilityTogglePage> createState() => _MerchantAvailabilityTogglePageState();
}

class _MerchantAvailabilityTogglePageState extends State<MerchantAvailabilityTogglePage> {
  String status = "Online";

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Availability Status",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Status:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(status, style: TextStyle(fontSize: 20, color: AppColors.neon)),
          const SizedBox(height: 24),
          DropdownButton<String>(
            value: status,
            items: ["Online", "Busy", "Offline"].map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => status = value);
              }
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Save status to backend
            },
            child: const Text("Update Status"),
          ),
        ],
      ),
    );
  }
}
