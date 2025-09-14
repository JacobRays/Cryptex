import 'package:flutter/material.dart';
import '../../theme.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.redAccent, size: 80),
            const SizedBox(height: 20),
            const Text("No Internet Connection", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Retry logic
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
