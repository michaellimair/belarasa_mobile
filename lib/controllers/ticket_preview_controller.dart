import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TicketPreviewController extends GetxController {
  late WebViewController webViewController;

  void setWebViewController(WebViewController controller) {
    webViewController = controller;
  }
}
