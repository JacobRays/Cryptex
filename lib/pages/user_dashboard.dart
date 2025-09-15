import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('User Dashboard', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balances
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _balanceCard('USDT', '150.00'),
                _balanceCard('MWK', '250,000'),
              ],
            ),
            const SizedBox(height: 20),
            // Buy/Sell buttons
            Row(
              children: [
                Expanded(child: _mainButton(context, 'Buy USDT/USD', Colors.blue)),
                const SizedBox(width: 10),
                Expanded(child: _mainButton(context, 'Sell USDT/USD', Colors.purple)),
              ],
            ),
            const SizedBox(height: 20),
            // My Sale Offers
            const Text('My Sale Offers', style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _offerCard('MerchantX', '1,000 MWK', 'Offers Received'),
                  _offerCard('MerchantY', '500 MWK', 'Pending Offers'),
                ],
              ),
            ),
            // Transaction History shortcut
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('View Transaction History', style: TextStyle(color: AppColors.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceCard(String currency, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(currency, style: const TextStyle(color: AppColors.textSecondary)),
          Text(amount, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _mainButton(BuildContext context, String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _offerCard(String merchant, String amount, String status) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        title: Text(merchant, style: const TextStyle(color: AppColors.textPrimary)),
        subtitle: Text(amount, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Text(status, style: const TextStyle(color: AppColors.success)),
      ),
    );
  }
}
