import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  // Balances (mock for now)
  double usdtBalance = 320.75;
  double mwkBalance = 685000;

  // Custom rates
  final TextEditingController _buyRateCtrl = TextEditingController(text: '1780');   // MWK per USDT
  final TextEditingController _sellRateCtrl = TextEditingController(text: '1825');

  // Availability
  String availability = 'Online'; // Online | Busy | Offline

  // Incoming sale offers (mock)
  final List<_SaleOffer> incomingOffers = [
    _SaleOffer(userMasked: 'user****91', amountUsdt: 150, timestamp: DateTime.now().subtract(const Duration(minutes: 7))),
    _SaleOffer(userMasked: 'user****24', amountUsdt: 40, timestamp: DateTime.now().subtract(const Duration(minutes: 25))),
  ];

  // Active trades (mock)
  final List<_ActiveTrade> activeTrades = [
    _ActiveTrade(id: 'TRD-2025-0001', amountUsdt: 100, status: 'In Progress'),
  ];

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
        title: const Text('Merchant Dashboard', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Balances'),
          Row(
            children: [
              Expanded(child: _balanceCard('USDT', usdtBalance.toStringAsFixed(2))),
              const SizedBox(width: 12),
              Expanded(child: _balanceCard('MWK', _fmtMoney(mwkBalance))),
            ],
          ),
          const SizedBox(height: 20),

          _sectionTitle('Set rates'),
          _rateRow('Buy rate (MWK/USDT)', _buyRateCtrl),
          const SizedBox(height: 10),
          _rateRow('Sell rate (MWK/USDT)', _sellRateCtrl),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                _toast(context, 'Rates saved: Buy ${_buyRateCtrl.text}, Sell ${_sellRateCtrl.text}');
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),

          _sectionTitle('Incoming sale offers'),
          if (incomingOffers.isEmpty)
            _emptyCard('No new sale offers')
          else
            ...incomingOffers.map((o) => _offerCard(context, o)).toList(),
          const SizedBox(height: 20),

          _sectionTitle('Active trades'),
          if (activeTrades.isEmpty)
            _emptyCard('No active trades')
          else
            ...activeTrades.map((t) => _tradeCard(t)).toList(),
          const SizedBox(height: 20),

          _sectionTitle('Availability'),
          _availabilityPicker(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

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

  Widget _rateRow(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
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
      ),
    );
  }

  Widget _offerCard(BuildContext context, _SaleOffer offer) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppColors.border)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text('${offer.amountUsdt.toStringAsFixed(2)} USDT', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        subtitle: Text('From: ${offer.userMasked} • ${_ago(offer.timestamp)}', style: const TextStyle(color: AppColors.textSecondary)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () => _openMakeOffer(context, offer),
          child: const Text('Make Offer', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _tradeCard(_ActiveTrade trade) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: AppColors.border)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text('${trade.amountUsdt.toStringAsFixed(2)} USDT', style: const TextStyle(color: AppColors.textPrimary)),
        subtitle: Text('${trade.id} • ${trade.status}', style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.timelapse, color: AppColors.warning),
      ),
    );
  }

  Widget _availabilityPicker() {
    final color = {
      'Online': AppColors.success,
      'Busy': AppColors.warning,
      'Offline': AppColors.error,
    }[availability]!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          const Text('Status', style: TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          DropdownButton<String>(
            value: availability,
            dropdownColor: AppColors.surface,
            iconEnabledColor: AppColors.textPrimary,
            items: const [
              DropdownMenuItem(value: 'Online', child: Text('Online', style: TextStyle(color: AppColors.textPrimary))),
              DropdownMenuItem(value: 'Busy', child: Text('Busy', style: TextStyle(color: AppColors.textPrimary))),
              DropdownMenuItem(value: 'Offline', child: Text('Offline', style: TextStyle(color: AppColors.textPrimary))),
            ],
            onChanged: (v) => setState(() => availability = v ?? availability),
          ),
        ],
      ),
    );
  }

  void _openMakeOffer(BuildContext context, _SaleOffer offer) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Propose MWK Amount', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Enter MWK',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              _toast(context, 'Offer sent: MWK ${ctrl.text} for ${offer.amountUsdt.toStringAsFixed(2)} USDT');
            },
            child: const Text('Send', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.surface,
      content: Text(msg, style: const TextStyle(color: AppColors.textPrimary)),
    ));
  }

  String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  String _fmtMoney(double v) => v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
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
  _ActiveTrade({required this.id, required this.amountUsdt, required this.status});
}
