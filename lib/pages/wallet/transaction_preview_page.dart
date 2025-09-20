import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/pin_sheet.dart';
import 'package:cryptex_malawi/services/pin_service.dart';

class TransactionPreview extends StatelessWidget {
  final String party;
  final double amountUsdt;
  final double amountMwk;
  final double baseRate;
  final double merchantRate;
  final double fees;

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
                        onPressed: () => _handlePinAndSubmit(context),
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
                        child: const 
