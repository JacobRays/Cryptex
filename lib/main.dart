import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

// This is required for Android versions of webview_flutter
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    WebView.platform = AndroidWebView();
  }
  runApp(const CryptexApp());
}

class CryptexApp extends StatelessWidget {
  const CryptexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRYPT-X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Using your PhoenixTheme colors
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: const WebShell(),
    );
  }
}

class WebShell extends StatefulWidget {
  const WebShell({super.key});
  @override
  State<WebShell> createState() => _WebShellState();
}

class _WebShellState extends State<WebShell> {
  late final WebViewController _controller;
  double _progress = 0;
  // This is the starting page of your HTML app from the assets/www folder
  final String startPage = 'dashboard.html';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _progress = p / 100),
        onNavigationRequest: _handleNavigation,
      ))
      ..loadFlutterAsset('assets/www/$startPage');
  }

  // This function decides what to do when a link is clicked
  Future<NavigationDecision> _handleNavigation(NavigationRequest request) async {
    final uri = Uri.parse(request.url);
    final scheme = uri.scheme.toLowerCase();

    // If the link is for WhatsApp, email, or a phone call, open it outside the app
    if (['mailto', 'tel', 'whatsapp'].contains(scheme) || uri.host.contains('wa.me')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return NavigationDecision.prevent; // Stop the WebView from navigating
    }

    // Allow all other navigation inside the app (to your other HTML pages)
    return NavigationDecision.navigate;
  }

  // Handle the Android back button
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false; // Don't close the app
    }
    return true; // Close the app if there's no history
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // We can remove the AppBar to make it feel more like a native app
        // If you want it back, just uncomment the appBar line.
        // appBar: AppBar(title: const Text('CRYPT-X')),
        body: SafeArea(
          // Add a Stack to show the loading bar on top of the WebView
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_progress < 1.0)
                LinearProgressIndicator(
                  value: _progress,
                  color: const Color(0xFFD4AF37),
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
