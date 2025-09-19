import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';
import 'package:cryptex_malawi/widgets/neon.dart';
import 'package:cryptex_malawi/services/kyc_service.dart';

class KycPage extends StatefulWidget {
  const KycPage({Key? key}) : super(key: key);
  @override
  _KycPageState createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  String _status = 'Pending';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final service = KycService(uid: 'current_user');
    final kyc = await service.fetchCurrentKyc();
    setState(() {
      _status = kyc.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC'), backgroundColor: AppColors.surface, elevation: 0),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeonText(text: 'KYC Status: $_status', fontSize: 22),
            const SizedBox(height: 12),
            NeonCard(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Upload required documents (ID, Selfie) and wait for approval. This is a MVP skeleton UI.', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(height: 12),
            NeonButton(label: 'Upload ID', onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID upload placeholder')));
            }),
            const SizedBox(height: 8),
            NeonButton(label: 'Upload Selfie', onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selfie upload placeholder')));
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                setState(() { _loading = true; });
                final service = KycService(uid: 'current_user');
                final kyc = await service.fetchCurrentKyc();
                await service.submitKyc(kyc..status = 'Pending');
                setState(() { _loading = false; _status = 'Pending'; });
              },
              child: _loading ? const CircularProgressIndicator() : const Text('Submit KYC'),
            ),
          ],
        ),
      ),
    );
  }
}
