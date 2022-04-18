import 'dart:io';

import 'package:belarasa_mobile/routes/pages.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:get/get.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TicketRegisterController extends GetxController {
  late WebViewController webViewController;
  late WebviewCookieManager webviewCookieManager;
  late List<WebViewCookie> initialCookies;
  RxBool isInitialized = false.obs;
  late String ticketLink;
  RxBool isLoaded = false.obs;

  void setWebViewController(WebViewController controller) {
    webViewController = controller;
  }

  // Shows the 'My Tickets' page under the assumption that user is registering for a mass.
  void incrementCounterOrShowTickets() async {
    if (!isLoaded.value) {
      isLoaded.toggle();
    } else {
      String? currentUrl = await webViewController.currentUrl();
      if (currentUrl == ticketLink) {
        Get.offNamed(Routes.tickets);
      }
    }
  }

  void initialize() async {
    ticketLink = Get.arguments[0] as String;
    webviewCookieManager = WebviewCookieManager();
    CookieService cookieService = Get.find<CookieService>();
    List<Cookie> cookies = await cookieService.loadForRequest(ticketLink);
    List<WebViewCookie> webviewCookies = cookies.map<WebViewCookie>((cookie) {
      return WebViewCookie(
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain ?? "belarasa.id",
        path: cookie.path ?? "/",
      );
    }).toList();
    List<Cookie> remappedCookies = cookies.map<Cookie>((c) {
      return Cookie(c.name, c.value)
        ..domain = c.domain ?? "belarasa.id"
        ..expires = c.expires
        ..path = c.path ?? "/";
    }).toList();
    await webviewCookieManager.setCookies(remappedCookies);
    initialCookies = webviewCookies;
    isInitialized.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    initialize();
  }
}
