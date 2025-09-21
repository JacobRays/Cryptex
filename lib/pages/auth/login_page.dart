import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';
import 'package:cryptex_malawi/pages/main_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  
  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainDashboard()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.blackPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.diamond,
                size: 80,
                color: PhoenixTheme.goldPrimary,
              ),
              SizedBox(height: 16),
              Text(
                'CRYPTEX MALAWI',
                style: TextStyle(
                  color: PhoenixTheme.goldPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'P2P USDT Trading',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 48),
              
              // Form
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: PhoenixTheme.goldPrimary),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: PhoenixTheme.goldPrimary),
                ),
              ),
              SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _authenticate,
                  child: _isLoading
                      ? CircularProgressIndicator(color: PhoenixTheme.blackPrimary)
                      : Text(_isLogin ? 'LOGIN' : 'SIGN UP'),
                ),
              ),
              SizedBox(height: 16),
              
              // Toggle
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? 'Need an account? Sign Up' : 'Already have an account? Login',
                  style: TextStyle(color: PhoenixTheme.goldPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
