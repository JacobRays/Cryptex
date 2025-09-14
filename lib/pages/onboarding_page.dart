import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        children: [
          _buildSlide("Buy & Sell USDT Easily", Icons.swap_horiz),
          _buildSlide("Fast Mobile Money Transfers", Icons.phone_android),
          _buildSlide("Secure with PIN + Escrow", Icons.lock),
        ],
      ),
    );
  }

  Widget _buildSlide(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.neon),
          const SizedBox(height: 20),
          Text(text, style: const TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 40),
          ElevatedButton(onPressed: () {}, child: const Text("Get Started")),
        ],
      ),
    );
  }
}
