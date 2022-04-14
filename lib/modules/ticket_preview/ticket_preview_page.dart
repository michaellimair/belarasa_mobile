import 'package:belarasa_mobile/controllers/ticket_preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TicketPreviewPage extends GetView<TicketPreviewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ticket_preview".tr),
        ),
        body: WebView(
          onWebViewCreated: (WebViewController webViewController) {
            controller.setWebViewController(webViewController);
            String ticketHtml = Get.arguments[0] as String;
            webViewController.loadHtmlString(ticketHtml);
          },
        ));
  }
}
