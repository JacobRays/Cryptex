import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/app_scaffold.dart';

class UserMerchantManagementPage extends StatelessWidget {
  const UserMerchantManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = ["Alice", "Bob", "Charlie"];
    final merchants = ["John Crypto", "Zed Exchange"];

    return AppScaffold(
      title: "Manage Users & Merchants",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Users"),
          ...users.map((user) => ListTile(
                title: Text(user),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: Ban or delete user
                  },
                  child: const Text("Ban"),
                ),
              )),
          const SizedBox(height: 24),
          const Text("Merchants"),
          ...merchants.map((merchant) => ListTile(
                title: Text(merchant),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: Approve or suspend merchant
                  },
                  child: const Text("Suspend"),
                ),
              )),
        ],
      ),
    );
  }
}
