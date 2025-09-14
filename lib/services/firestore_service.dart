import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_model.dart';
import 'firebase_service.dart';

class FirestoreService {
  static final _db = FirebaseService.db;

  static Future<Wallet?> getWallet(String userId) async {
    final snap = await _db
      .collection('wallets')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();
    if (snap.docs.isEmpty) return null;
    final d = snap.docs.first;
    return Wallet.fromMap(d.id, d.data());
  }

  static Future<Wallet> ensureWallet(String userId) async {
    final existing = await getWallet(userId);
    if (existing != null) return existing;
    final ref = await _db.collection('wallets').add({
      'userId': userId,
      'usdtBalance': 0.0,
      'mwkBalance': 0.0,
    });
    final doc = await ref.get();
    return Wallet.fromMap(doc.id, doc.data()!);
  }

  static Future<void> updateWallet(Wallet w) async {
    await _db.collection('wallets').doc(w.id).update(w.toMap());
  }

  static Future<void> addTx(Map<String, dynamic> data) async {
    await _db.collection('transactions').add({
      ...data,
      'createdAt': Timestamp.now(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> txStream(String userId) {
    return _db
      .collection('transactions')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots();
  }
}
