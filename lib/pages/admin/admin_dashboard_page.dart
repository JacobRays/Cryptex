import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), backgroundColor: AppColors.surface, elevation: 0),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            NeonCard(child: ListTile(title: NeonText(text: 'Global Rate Mgmt', fontSize: 16), onTap: () {})),
            NeonCard(child: ListTile(title: NeonText(text: 'Escrow Mgmt', fontSize: 16), onTap: () {})),
            NeonCard(child: ListTile(title: NeonText(text: 'Fee Wallet', fontSize: 16), onTap: () {})),
            NeonCard(child: ListTile(title: NeonText(text: 'User/Merchant Mgmt', fontSize: 16), onTap: () {})),
          ],
        ),
      ),
    );
  }
}
