import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../app_router.dart';

class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  const RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: AuthService.currentUserDoc(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snap.data;
        if (user == null || !allowedRoles.contains(user.role)) {
          Future.microtask(() => Navigator.pushReplacementNamed(context, AppRoutes.home));
          return const SizedBox.shrink();
        }
        return child;
      },
    );
  }
}
