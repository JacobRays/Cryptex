import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Global base rates
  final TextEditingController _baseBuyCtrl = TextEditingController(text: '1800');
  final TextEditingController _baseSellCtrl = TextEditingController(text: '1820');
  bool autoUpdate = false;

  // Default merchant wallet (admin-as-merchant)
  double adminUsdt = 850.0;
  double adminMwk = 1250000;

  // Fee wallet
  double feesUsdt = 42.6;
  double feesMwk = 375000;

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
        title: const Text('Admin Dashboard', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _title('Global rate management'),
          _rateCard(),
          const SizedBox(height: 20),

          _title('Default merchant wallet (Admin)'),
          Row(
            children: [
              Expanded(child: _balanceCard('USDT', adminUsdt.toStringAsFixed(2))),
              const SizedBox(width: 12),
              Expanded(child: _balanceCard('MWK', _fmtMoney(adminMwk))),
            ],
          ),
          const SizedBox(height: 20),

          _title('Escrow management'),
          _actionTile(
            icon: Icons.lock_open,
            color: AppColors.primary,
            title: 'Open Escrow Tools',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: AppColors.surface,
                content: Text('Navigate to Escrow Management', style: TextStyle(color: AppColors.textPrimary)),
              ));
            },
          ),
          const SizedBox(height: 12),

          _title('Fee collection wallet'),
          Row(
            children: [
              Expanded(child: _balanceCard('USDT', feesUsdt.toStringAsFixed(2))),
              const SizedBox(width: 12),
              Expanded(child: _balanceCard('MWK', _fmtMoney(feesMwk))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => _toast(context, 'Withdraw fees (USDT)'),
                  child: const Text('Withdraw USDT', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => _toast(context, 'Withdraw fees (MWK)'),
                  child: const Text('Withdraw MWK', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _title('Merchant approval'),
          _actionTile(
            icon: Icons.verified_user,
            color: AppColors.success,
            title: 'Approve / Ban Merchants',
            onTap: () => _toast(context, 'Open merchant approval'),
          ),
        ],
      ),
    );
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
  );

  Widget _balanceCard(String currency, String amount) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(currency, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text(amount, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _rateCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _rateRow('Base buy rate (MWK/USDT)', _baseBuyCtrl),
          const SizedBox(height: 10),
          _rateRow('Base sell rate (MWK/USDT)', _baseSellCtrl),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: autoUpdate,
            onChanged: (v) => setState(() => autoUpdate = v),
            activeColor: AppColors.primary,
            title: const Text('Auto update from market', style: TextStyle(color: AppColors.textPrimary)),
            subtitle: const Text('If off, manual rates apply', style: TextStyle(color: AppColors.textSecondary)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => _toast(context, 'Global rates saved'),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateRow(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
        const SizedBox(width: 10),
        SizedBox(
          width: 130,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              hintText: '0',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionTile({required IconData icon, required Color color, required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(color: AppColors.textPrimary))),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.surface,
      content: Text(msg, style: const TextStyle(color: AppColors.textPrimary)),
    ));
  }

  String _fmtMoney(double v) => v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}
