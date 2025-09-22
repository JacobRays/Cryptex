import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_malawi/services/app_state.dart';
import 'package:cryptex_malawi/routes/app_routes.dart';
import 'package:cryptex_malawi/theme/phoenix_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
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
        initialRoute: AppRoutes.initial,
        routes: AppRoutes.routes,
      ),
    );
  }
}
