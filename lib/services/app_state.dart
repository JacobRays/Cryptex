import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? currentUser;
  Map<String, dynamic>? userData;
  double usdtBalance = 0.0;
  double mwkBalance = 0.0;
  double globalRate = 1820.0; // Default rate
  double minFee = 15.0; // Minimum fee in MWK
  double feePercentage = 0.5; // 0.5% fee
  
  List<Map<String, dynamic>> merchants = [];
  List<Map<String, dynamic>> transactions = [];
  
  AppState() {
    _initializeUser();
    _loadGlobalSettings();
    _loadMerchants();
  }
  
  Future<void> _initializeUser() async {
    _auth.authStateChanges().listen((User? user) async {
      currentUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      }
      notifyListeners();
    });
  }
  
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userData = doc.data();
        usdtBalance = (userData?['usdtBalance'] ?? 0).toDouble();
        mwkBalance = (userData?['mwkBalance'] ?? 0).toDouble();
        await _loadUserTransactions(uid);
      } else {
        // Create new user document
        await _createUserDocument(uid);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
    notifyListeners();
  }
  
  Future<void> _createUserDocument(String uid) async {
    userData = {
      'uid': uid,
      'email': currentUser?.email,
      'role': 'user',
      'isMerchant': false,
      'usdtBalance': 0.0,
      'mwkBalance': 0.0,
      'totalVolume': 0.0,
      'joinedAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'kycVerified': false,
    };
    
    // Make first user admin
    final usersCount = await _firestore.collection('users').count().get();
    if (usersCount.count == 0) {
      userData!['role'] = 'admin';
      userData!['isMerchant'] = true;
    }
    
    await _firestore.collection('users').doc(uid).set(userData!);
  }
  
  Future<void> _loadGlobalSettings() async {
    try {
      final doc = await _firestore.collection('settings').doc('global').get();
      if (doc.exists) {
        globalRate = (doc.data()?['baseRate'] ?? 1820).toDouble();
        minFee = (doc.data()?['minFee'] ?? 15).toDouble();
        feePercentage = (doc.data()?['feePercentage'] ?? 0.5).toDouble();
      } else {
        // Create default settings
        await _firestore.collection('settings').doc('global').set({
          'baseRate': 1820.0,
          'minFee': 15.0,
          'feePercentage': 0.5,
        });
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
    notifyListeners();
  }
  
  Future<void> _loadMerchants() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('isMerchant', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();
      
      merchants = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading merchants: $e');
    }
    notifyListeners();
  }
  
  Future<void> _loadUserTransactions(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      
      transactions = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading transactions: $e');
    }
    notifyListeners();
  }
  
  // Trading functions
  Future<bool> buyUSDT(double amount, String merchantId) async {
    if (currentUser == null) return false;
    
    try {
      final mwkAmount = amount * globalRate;
      final fee = calculateFee(mwkAmount);
      final totalMwk = mwkAmount + fee;
      
      if (mwkBalance < totalMwk) {
        throw Exception('Insufficient MWK balance');
      }
      
      // Create transaction
      final transactionId = _firestore.collection('transactions').doc().id;
      await _firestore.collection('transactions').doc(transactionId).set({
        'id': transactionId,
        'type': 'BUY',
        'userId': currentUser!.uid,
        'merchantId': merchantId,
        'usdtAmount': amount,
        'mwkAmount': mwkAmount,
        'fee': fee,
        'rate': globalRate,
        'status': 'PENDING',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Update balances
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'mwkBalance': FieldValue.increment(-totalMwk),
        'usdtBalance': FieldValue.increment(amount),
      });
      
      mwkBalance -= totalMwk;
      usdtBalance += amount;
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Error buying USDT: $e');
      return false;
    }
  }
  
  Future<bool> sellUSDT(double amount, String merchantId) async {
    if (currentUser == null) return false;
    
    try {
      if (usdtBalance < amount) {
        throw Exception('Insufficient USDT balance');
      }
      
      final mwkAmount = amount * globalRate;
      final fee = calculateFee(mwkAmount);
      final netMwk = mwkAmount - fee;
      
      // Create transaction
      final transactionId = _firestore.collection('transactions').doc().id;
      await _firestore.collection('transactions').doc(transactionId).set({
        'id': transactionId,
        'type': 'SELL',
        'userId': currentUser!.uid,
        'merchantId': merchantId,
        'usdtAmount': amount,
        'mwkAmount': mwkAmount,
        'fee': fee,
        'rate': globalRate,
        'status': 'PENDING',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Update balances
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'usdtBalance': FieldValue.increment(-amount),
        'mwkBalance': FieldValue.increment(netMwk),
      });
      
      usdtBalance -= amount;
      mwkBalance += netMwk;
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Error selling USDT: $e');
      return false;
    }
  }
  
  double calculateFee(double amount) {
    final percentageFee = amount * (feePercentage / 100);
    return percentageFee > minFee ? percentageFee : minFee;
  }
  
  Future<void> applyForMerchant() async {
    if (currentUser == null || userData == null) return;
    
    if (usdtBalance >= 100) {
      await _firestore.collection('merchant_applications').add({
        'userId': currentUser!.uid,
        'email': userData!['email'],
        'usdtBalance': usdtBalance,
        'status': 'PENDING',
        'appliedAt': FieldValue.serverTimestamp(),
      });
    }
  }
  
  bool get canApplyForMerchant => usdtBalance >= 100 && !(userData?['isMerchant'] ?? false);
  bool get isAdmin => userData?['role'] == 'admin';
  bool get isMerchant => userData?['isMerchant'] ?? false;
}
