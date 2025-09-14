import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  static final _auth = FirebaseService.auth;
  static final _db = FirebaseService.db;

  static Stream<User?> get authState => _auth.authStateChanges();

  static Future<AppUser?> currentUserDoc() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final doc = await _db.collection('users').doc(u.uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDoc(doc);
  }

  static Future<AppUser?> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email, password: password
    );
    final user = AppUser(
      uid: cred.user!.uid,
      name: name,
      email: email,
      role: role,
      createdAt: DateTime.now(),
    );
    await _db.collection('users').doc(user.uid).set(user.toMap());
    // initial wallet
    await _db.collection('wallets').add({
      'userId': user.uid,
      'usdtBalance': 0.0,
      'mwkBalance': 0.0,
    });
    return user;
  }

  static Future<AppUser?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email, password: password
    );
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    return AppUser.fromDoc(doc);
  }

  static Future<void> forgotPassword(String email) =>
    _auth.sendPasswordResetEmail(email: email);

  static Future<void> logout() => _auth.signOut();
}
