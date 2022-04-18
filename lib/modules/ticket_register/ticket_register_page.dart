import 'package:belarasa_mobile/controllers/ticket_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TicketRegisterPage extends GetView<TicketRegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("mass_registration".tr),
        ),
        body: Obx(() => !controller.isInitialized.value
            ? const Center(child: CircularProgressIndicator())
            : WebView(
                onWebViewCreated: (WebViewController webViewController) {
                  controller.setWebViewController(webViewController);
                },
                onPageFinished: (String _content) async {
                  controller.incrementCounterOrShowTickets();
                },
                initialUrl: controller.ticketLink,
                initialCookies: controller.initialCookies,
                javascriptMode: JavascriptMode.unrestricted,
              )));
  }
}
