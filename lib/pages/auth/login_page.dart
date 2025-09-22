import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';
import 'package:cryptex_malawi/pages/main_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _usePhone = false;
  
  Future<void> _authenticate() async {
    if (_emailPhoneController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please fill all fields');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      UserCredential userCredential;
      
      if (_isLogin) {
        // LOGIN
        String email = _emailPhoneController.text.trim();
        if (_usePhone) {
          // Convert phone to email format for auth
          email = '${_emailPhoneController.text.trim()}@cryptex.mw';
        }
        
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: _passwordController.text.trim(),
        );
      } else {
        // REGISTER
        if (_usernameController.text.isEmpty) {
          _showError('Username is required');
          setState(() => _isLoading = false);
          return;
        }
        
        String email = _emailPhoneController.text.trim();
        if (_usePhone) {
          // Convert phone to email format
          email = '${_emailPhoneController.text.trim()}@cryptex.mw';
        }
        
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: _passwordController.text.trim(),
        );
        
        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'username': _usernameController.text.trim(),
          'email': email,
          'phone': _usePhone ? _emailPhoneController.text.trim() : '',
          'role': 'user',
          'isMerchant': false,
          'usdtBalance': 0.0,
          'mwkBalance': 0.0,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainDashboard()),
      );
    } catch (e) {
      String errorMessage = 'Authentication failed';
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'User not found';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Wrong password';
      } else if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Email/Phone already registered';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Password too weak';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Invalid email/phone format';
      }
      _showError(errorMessage);
    }
    
    setState(() => _isLoading = false);
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PhoenixTheme.error,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.blackPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.diamond,
                  size: 60,
                  color: PhoenixTheme.goldPrimary,
                ),
                SizedBox(height: 16),
                Text(
                  'CRYPTEX MALAWI',
                  style: TextStyle(
                    color: PhoenixTheme.goldPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 32),
                
                // Toggle Email/Phone
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text('Email'),
                      selected: !_usePhone,
                      onSelected: (value) => setState(() => _usePhone = false),
                      selectedColor: PhoenixTheme.goldPrimary,
                      labelStyle: TextStyle(
                        color: !_usePhone ? PhoenixTheme.blackPrimary : Colors.white,
                      ),
                    ),
                    SizedBox(width: 16),
                    ChoiceChip(
                      label: Text('Phone'),
                      selected: _usePhone,
                      onSelected: (value) => setState(() => _usePhone = true),
                      selectedColor: PhoenixTheme.goldPrimary,
                      labelStyle: TextStyle(
                        color: _usePhone ? PhoenixTheme.blackPrimary : Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // Username field (only for register)
                if (!_isLogin)
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person, color: PhoenixTheme.goldPrimary),
                      hintText: 'Choose a username',
                    ),
                  ),
                if (!_isLogin) SizedBox(height: 16),
                
                // Email/Phone field
                TextField(
                  controller: _emailPhoneController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: _usePhone ? TextInputType.phone : TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: _usePhone ? 'Phone Number' : 'Email',
                    prefixIcon: Icon(
                      _usePhone ? Icons.phone : Icons.email,
                      color: PhoenixTheme.goldPrimary,
                    ),
                    hintText: _usePhone ? '0991234567' : 'email@example.com',
                    prefixText: _usePhone ? '+265 ' : null,
                  ),
                ),
                SizedBox(height: 16),
                
                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: PhoenixTheme.goldPrimary),
                    hintText: 'Min 6 characters',
                  ),
                ),
                SizedBox(height: 24),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _authenticate,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(PhoenixTheme.blackPrimary),
                            ),
                          )
                        : Text(
                            _isLogin ? 'LOGIN' : 'REGISTER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Toggle Login/Register
                TextButton(
                  onPressed: () => setState(() {
                    _isLogin = !_isLogin;
                    // Clear fields when switching
                    _usernameController.clear();
                    _emailPhoneController.clear();
                    _passwordController.clear();
                  }),
                  child: Text(
                    _isLogin 
                        ? "Don't have an account? Register" 
                        : 'Already have an account? Login',
                    style: TextStyle(color: PhoenixTheme.goldPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
