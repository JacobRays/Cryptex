import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// These imports are now only used in the web-specific part,
// but we keep them here for simplicity and handle them with checks.
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && Platform.isAndroid) {
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFE0C16A),
          background: Color(0xFF121212),
          surface: Color(0xFF2C2C2C),
          error: Color(0xFFF44336),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
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
  // Make the controller nullable, as it's not used on web
  WebViewController? _controller;
  double _progress = 0;
  final String startPage = 'dashboard.html';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      // This code will ONLY run on mobile (Android/iOS)
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p / 100),
          onNavigationRequest: _navDecision,
        ))
        ..loadFlutterAsset('assets/www/$startPage');
    } else {
      // This code will ONLY run on web
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory('cryptex-iframe', (int viewId) {
        final iframe = html.IFrameElement()
          ..style.border = '0'
          ..style.width = '100%'
          ..style.height = '100%'
          ..src = 'app/$startPage';
        return iframe;
      });
    }
  }

  Future<NavigationDecision> _navDecision(NavigationRequest req) async {
    final uri = Uri.tryParse(req.url);
    if (uri == null) return NavigationDecision.navigate;

    final scheme = uri.scheme.toLowerCase();
    if (['mailto', 'tel', 'whatsapp'].contains(scheme) || uri.host.contains('wa.me')) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return NavigationDecision.prevent;
    }
    if (req.url.startsWith('file://') || req.url.startsWith('flutter-asset://')) {
      return NavigationDecision.navigate;
    }
    if (uri.host.isNotEmpty) {
       if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<bool> _onWillPop() async {
    if (!kIsWeb && _controller != null && await _controller!.canGoBack()) {
      _controller!.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('CRYPT-X'),
      centerTitle: true,
      actions: [
        if (!kIsWeb && _controller != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller!.reload(),
            tooltip: 'Reload',
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: (!kIsWeb && _progress < 1.0)
            ? LinearProgressIndicator(
                value: _progress,
                color: const Color(0xFFD4AF37),
                backgroundColor: Colors.black26,
              )
            : const SizedBox(height: 2),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final canGoBack = await _onWillPop();
        if(canGoBack && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: kIsWeb
              ? const HtmlElementView(viewType: 'cryptex-iframe')
              : (_controller != null ? WebViewWidget(controller: _controller!) : const Center(child: Text("WebView not supported on this platform"))),
        ),
      ),
    );
  }
}
