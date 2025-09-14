import 'package:flutter/material.dart';
import '../theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120),
            const SizedBox(height: 20),
            const Text(
              "Cryptex Malawi",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.neon,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Buy & Sell USDT with Kwacha",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.neon),
          ],
        ),
      ),
    );
  }
}
