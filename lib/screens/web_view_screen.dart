import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      // 1️⃣ Cho phép JavaScript
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // 2️⃣ Bắt điều hướng
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            debugPrint('WEBVIEW URL: $url');

            final uri = Uri.parse(url);

            // 1️⃣ intent://
            if (uri.scheme == 'intent') {
              try {
                final package =
                    uri.queryParameters['package'] ?? 'vn.com.vng.zalopay';

                final zalopayUri = Uri.parse('zalopay://pay');

                if (await canLaunchUrl(zalopayUri)) {
                  await launchUrl(
                    zalopayUri,
                    mode: LaunchMode.externalApplication, // Mở app ZaloPay
                  );
                } else {
                  await launchUrl(
                    Uri.parse('market://details?id=$package'),
                    mode: LaunchMode.externalApplication, // Mở CH Play
                  );
                }
              } catch (e) {
                debugPrint('Intent error: $e');
              }

              return NavigationDecision.prevent;
            }

            // 2️⃣ zalopay:// hoặc zalo://
            if (uri.scheme == 'zalopay' ||
                uri.scheme == 'zalo' ||
                uri.scheme == "hotelbooking") {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                await launchUrl(
                  Uri.parse('market://details?id=vn.com.vng.zalopay'),
                  mode: LaunchMode.externalApplication, // Mở CH Play
                );
              }

              return NavigationDecision.prevent; // Ngăn WebView xử lý
            }

            // 3️⃣ market://
            if (uri.scheme == 'market') {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }

            // 4️⃣ http / https cho WebView xử lý
            return NavigationDecision.navigate;
          },
        ),
      )
      // 3️⃣ Load URL ban đầu
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        centerTitle: true,
        leading: IconButton(
          // onPressed: () => context.go("/home"),
          onPressed: () {
            context.go("/calendar");
            context.push("/calendar_detail");
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
