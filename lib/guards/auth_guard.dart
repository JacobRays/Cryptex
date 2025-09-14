import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../app_router.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.authState,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snap.hasData) {
          Future.microtask(() => Navigator.pushReplacementNamed(context, AppRoutes.login));
          return const SizedBox.shrink();
        }
        return child;
      },
    );
  }
}
