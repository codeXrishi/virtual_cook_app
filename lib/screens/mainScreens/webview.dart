import 'package:flutter/material.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  //initialized webview here
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse(
        'https://doc-hosting.flycricket.io/virtual-cook-privacy-policy/dfd2557d-92ea-41c8-8bc9-13fe8fddf7ea/privacy'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        centerTitle: true,
        backgroundColor: AppColor.KPinkColor,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
