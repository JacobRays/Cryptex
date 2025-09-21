import 'package:flutter/material.dart';
import 'package:cryptex_malawi/routes/app_routes.dart';

void main() {
  runApp(CryptexApp());
}

class CryptexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cryptex Malawi',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF00D4FF),
        scaffoldBackgroundColor: Color(0xFF0A0E27),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
    );
  }
}
