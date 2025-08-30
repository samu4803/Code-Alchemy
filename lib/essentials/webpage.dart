import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  bool loadingWebsite = false;
  WebViewController? controller;
  WebViewController getController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!loadingWebsite) {
              loadingWebsite = true;
              setState(() {});
            }
            if (progress == 100) {
              loadingWebsite = false;
              setState(() {});
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://aicode-ff349.web.app/'),
      );
    return controller!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Website"),
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share(
                  "\n https://codealchemy-ai.web.app",
                );
              },
              icon: const Icon(
                Icons.share,
              )),
        ],
      ),
      // extendBodyBehindAppBar: true,
      body: loadingWebsite == true
          ? const LoadingAnimation()
          : WebViewWidget(
              controller: controller ?? getController(),
            ),
    );
  }
}
