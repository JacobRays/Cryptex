import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class MerchantDashboard extends StatefulWidget {
  MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  final TextEditingController _buyRateCtrl = TextEditingController(text: '1800');
  final TextEditingController _sellRateCtrl = TextEditingController(text: '1820');

  double usdtBalance = 500.0;
  double mwkBalance = 900000;

  final List<_SaleOffer> incomingOffers = [
    _SaleOffer(userMasked: 'user****91', amountUsdt: 150, timestamp: DateTime.now().subtract(Duration(minutes: 7))),
    _SaleOffer(userMasked: 'user****24', amountUsdt: 40, timestamp: DateTime.now().subtract(Duration(minutes: 25))),
  ];

  final List<_ActiveTrade> activeTrades = [
    _ActiveTrade(id: 'TRD-2025-0001', amountUsdt: 100, status: 'In Progress'),
    _ActiveTrade(id: 'TRD-2025-0002', amountUsdt: 50, status: 'Pending Payment'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Merchant Dashboard', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _title('Wallet Balances'),
          Row(
            children: [
              Expanded(child: _balanceCard('USDT', usdtBalance.toStringAsFixed(2))),
              const SizedBox(width: 12),
              Expanded(child: _balanceCard('MWK', _fmtMoney(mwkBalance))),
            ],
          ),
          const SizedBox(height: 20),
          _title('Set Rates'),
          _rateCard(),
          const SizedBox(height: 20),
          _title('Incoming Offers'),
          ...incomingOffers.map((o) => _offerCard(context, o)),
          const SizedBox(height: 20),
          _title('Active Trades'),
          ...activeTrades.map((t) => _tradeCard(t)),
        ],
      ),
    );
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
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
          Text(currency, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text(amount, style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
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
          _rateRow('Buy rate (MWK/USDT)', _buyRateCtrl),
          const SizedBox(height: 10),
          _rateRow('Sell rate (MWK/USDT)', _sellRateCtrl),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              _toast(context, 'Rates saved: Buy ${_buyRateCtrl.text}, Sell ${_sellRateCtrl.text}');
            },
            child: Text('Save Rates', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _rateRow(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(color: AppColors.textSecondary))),
        const SizedBox(width: 10),
        SizedBox(
          width: 130,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              hintText: '0',
              hintStyle: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _offerCard(BuildContext context, _SaleOffer offer) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        title: Text('${offer.amountUsdt.toStringAsFixed(2)} USDT', style: TextStyle(color: AppColors.textPrimary)),
        subtitle: Text('From: ${offer.userMasked} • ${_ago(offer.timestamp)}', style: TextStyle(color: AppColors.textSecondary)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () => _openMakeOffer(context, offer),
          child: Text('Make Offer', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _tradeCard(_ActiveTrade trade) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        title: Text('${trade.amountUsdt.toStringAsFixed(2)} USDT', style: TextStyle(color: AppColors.textPrimary)),
        subtitle: Text('Trade ID: ${trade.id} • Status: ${trade.status}', style: TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }

  void _openMakeOffer(BuildContext context, _SaleOffer offer) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Propose MWK Amount', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter MWK',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              _toast(context, 'Offer sent: MWK ${ctrl.text} for ${offer.amountUsdt.toStringAsFixed(2)} USDT');
            },
            child: Text('Send', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface,
        content: Text(msg, style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }

  String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  String _fmtMoney(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (m) => '${m[1]},');
}

class _SaleOffer {
  final String userMasked;
  final double amountUsdt;
  final DateTime timestamp;
  _SaleOffer({required this.userMasked, required this.amountUsdt, required this.timestamp});
}

class _ActiveTrade {
  final String id;
  final double amountUsdt;
  final String status;
  _ActiveTrade({required this.id, required this.amountUsdt, required
