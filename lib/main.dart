import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_malawi/services/app_state.dart';
import 'package:cryptex_malawi/pages/auth/login_page.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase init error: $e');
  }
  runApp(PhoenixCryptex());
}

class PhoenixCryptex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Cryptex Malawi',
        theme: PhoenixTheme.darkGoldTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(), // Go straight to login
      ),
    );
  }
}
