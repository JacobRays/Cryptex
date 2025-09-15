import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class EscrowManagementPage extends StatefulWidget {
  const EscrowManagementPage({super.key});

  @override
  State<EscrowManagementPage> createState() => _EscrowManagementPageState();
}

class _EscrowManagementPageState extends State<EscrowManagementPage> {
  // Disputed transactions (mock)
  final List<_Dispute> disputes = [
    _Dispute(
      id: 'ESC-2025-0009',
      user: 'user****73',
      merchant: 'MerchantX',
      amountUsdt: 75,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      evidence: ['chat_log.pdf', 'receipt.png'],
    ),
    _Dispute(
      id: 'ESC-2025-0014',
      user: 'user****31',
      merchant: 'MerchantY',
      amountUsdt: 20,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      evidence: ['screenshot.jpg'],
    ),
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
        title: const Text('Escrow Management', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: disputes.length,
        itemBuilder: (_, i) => _disputeCard(context, disputes[i]),
      ),
    );
  }

  Widget _disputeCard(BuildContext context, _Dispute d) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d.id, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('User: ${d.user}  •  Merchant: ${d.merchant}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text('Amount: ${d.amountUsdt.toStringAsFixed(2)} USDT', style: const TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text('Created: ${_ago(d.createdAt)}', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            const Text('Evidence:', style: TextStyle(color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: d.evidence.map((e) => _evidenceChip(e)).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () => _confirm(context, 'Release funds to Merchant?', 'Funds released to ${d.merchant}'),
                    child: const Text('Release to Merchant', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    onPressed: () => _confirm(context, 'Refund User?', 'Refunded ${d.user}'),
                    child: const Text('Refund User', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _evidenceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
    );
  }

  void _confirm(BuildContext context, String question, String successMsg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(question, style: const TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors.surface,
                content: Text(successMsg, style: const TextStyle(color: AppColors.textPrimary)),
              ));
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

class _Dispute {
  final String id;
  final String user;
  final String merchant;
  final double amountUsdt;
  final DateTime createdAt;
  final List<String> evidence;
  _Dispute({
    required this.id,
    required this.user,
    required this.merchant,
    required this.amountUsdt,
    required this.createdAt,
    required this.evidence,
  });
}
