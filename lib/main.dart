import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cryptex_malawi/routes/app_routes.dart';
import 'package:cryptex_malawi/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CryptexApp());
}

class CryptexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptex Malawi',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
    );
  }
}
