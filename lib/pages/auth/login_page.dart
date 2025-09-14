import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Login",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset('assets/logo.png', height: 100),
          const SizedBox(height: 20),
          const NeonText(text: "Cryptex Malawi", fontSize: 28),
          const SizedBox(height: 8),
          const Text("Buy & Sell USDT with Kwacha", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          TextField(
            decoration: const InputDecoration(labelText: "Email or Phone"),
          ),
          const SizedBox(height: 12),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          const SizedBox(height: 24),
          NeonButton(label: "Login", onPressed: () {
            // TODO: Add login logic
          }),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // TODO: Navigate to RegisterPage
            },
            child: const Text("Don't have an account? Register"),
          ),
        ],
      ),
    );
  }
}
