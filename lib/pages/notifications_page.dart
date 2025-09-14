import 'package:flutter/material.dart';
import '../theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      "Merchant John is now Online",
      "You received 50 USDT",
      "Admin updated exchange rate",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.surface,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(notifications[index]),
              trailing: const Icon(Icons.notifications),
            ),
          );
        },
      ),
    );
  }
}
