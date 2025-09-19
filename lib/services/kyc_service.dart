import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptex_malawi/models/kyc.dart';

class KycService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;
  KycService({required this.uid});

  Future<Kyc> fetchCurrentKyc() async {
    try {
      final doc = await _firestore.collection('kyc').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Kyc(
          id: doc.id,
          status: data['status'] ?? 'Pending',
          idDocRef: data['idDocRef'],
          selfieDocRef: data['selfieDocRef'],
          submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
        );
      } else {
        return Kyc(id: uid, status: 'Pending');
      }
    } catch (e) {
      return Kyc(id: uid, status: 'Pending');
    }
  }

  Future<void> submitKyc(Kyc kyc) async {
    await _firestore.collection('kyc').doc(uid).set({
      'status': kyc.status,
      'idDocRef': kyc.idDocRef,
      'selfieDocRef': kyc.selfieDocRef,
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }
}
