import 'package:flutter/material.dart';
import '../theme.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Need Help?", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Open FAQ
              },
              child: const Text("View FAQs"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Start live chat
              },
              child: const Text("Live Chat"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Submit support ticket
              },
              child: const Text("Submit Ticket"),
            ),
          ],
        ),
      ),
    );
  }
}
