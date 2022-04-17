import 'dart:io';

import 'package:belarasa_mobile/routes/pages.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TicketRegisterController extends GetxController {
  late WebViewController webViewController;
  late List<WebViewCookie> initialCookies;
  RxBool isInitialized = false.obs;
  late String ticketLink;
  RxBool isLoaded = false.obs;

  void setWebViewController(WebViewController controller) {
    webViewController = controller;
  }

  // Shows the 'My Tickets' page under the assumption that user is registering for a mass.
  void incrementCounterOrShowTickets() {
    if (!isLoaded.value) {
      isLoaded.toggle();
    } else {
      Get.offNamed(Routes.tickets);
    }
  }

  void initialize() async {
    ticketLink = Get.arguments[0] as String;
    CookieService cookieService = Get.find<CookieService>();
    List<Cookie> cookies = await cookieService.loadForRequest(ticketLink);
    List<WebViewCookie> webviewCookies = cookies.map<WebViewCookie>((cookie) {
      return WebViewCookie(
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain ?? "https://belarasa.id",
        path: cookie.path ?? "/",
      );
    }).toList();
    initialCookies = webviewCookies;
    isInitialized.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    initialize();
  }
}
