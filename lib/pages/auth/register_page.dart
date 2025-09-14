import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/neon.dart';
import '../../widgets/app_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Register",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const NeonText(text: "Create Account", fontSize: 24),
          const SizedBox(height: 20),
          TextField(decoration: const InputDecoration(labelText: "Full Name")),
          const SizedBox(height: 12),
          TextField(decoration: const InputDecoration(labelText: "Email or Phone")),
          const SizedBox(height: 12),
          TextField(obscureText: true, decoration: const InputDecoration(labelText: "Password")),
          const SizedBox(height: 12),
          TextField(obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password")),
          const SizedBox(height: 24),
          NeonButton(label: "Register", onPressed: () {
            // TODO: Add registration logic
          }),
        ],
      ),
    );
  }
}
