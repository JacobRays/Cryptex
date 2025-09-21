import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';
import 'package:cryptex_malawi/pages/auth/login_page.dart';
import 'package:cryptex_malawi/pages/main_dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  
  Future<void> _checkAuth() async {
    await Future.delayed(Duration(seconds: 2));
    
    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null ? MainDashboard() : LoginPage(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.blackPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond,
              size: 100,
              color: PhoenixTheme.goldPrimary,
            ),
            SizedBox(height: 24),
            Text(
              'CRYPTEX MALAWI',
              style: TextStyle(
                color: PhoenixTheme.goldPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Secure P2P Trading',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(PhoenixTheme.goldPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
