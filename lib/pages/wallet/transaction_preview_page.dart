import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/pin_modal.dart';

class TransactionPreview extends StatelessWidget {
  final String party;          // Merchant or counterparty name
  final double amountUsdt;
  final double amountMwk;
  final double baseRate;       // Admin base rate
  final double merchantRate;   // Merchant’s actual rate
  final double fees;           // Total fees MWK

  TransactionPreview({
    Key? key,
    this.party = 'MerchantX',
    this.amountUsdt = 100,
    this.amountMwk = 182000,
    this.baseRate = 1800,
    this.merchantRate = 1820,
    this.fees = 1500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = amountMwk + fees;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Confirm Transaction', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _row('Party', party),
                _row('Amount', '${amountUsdt.toStringAsFixed(2)} USDT • ${_fmtMoney(amountMwk)} MWK'),
                _row('Base rate', '${_fmtMoney(baseRate)} MWK/USDT'),
                _row('Merchant rate', '${_fmtMoney(merchantRate)} MWK/USDT'),
                _row('Fees', '${_fmtMoney(fees)} MWK'),
                const Divider(color: AppColors.border),
                _row('Total', '${_fmtMoney(total)} MWK', emphasize: true),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => _showPinSheet(context),
                        child: const Text('SEND', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: emphasize ? 18 : 16,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showPinSheet(BuildContext context) {
    PinModal.show(
      context,
      onSubmit: (pin) {
        // In a full flow, verify the PIN securely here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surface,
            content: const Text('PIN verified. Sending…', style: TextStyle(color: AppColors.textPrimary)),
          ),
        );
      },
    );
  }

  String _fmtMoney(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}
