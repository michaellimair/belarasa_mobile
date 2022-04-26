import 'dart:io';

import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class LoginProvider extends GetConnect {
  Future<Response<String>> login(String email, String password) async {
    Response<String> initialResponse = await get('https://belarasa.id');
    if (initialResponse.bodyString == null) {
      throw Exception('Empty Response!');
    }
    Document document = parse(initialResponse.bodyString);
    Element signInFormElement = document.querySelector("#formSignIn")!;
    String csrfTestName = signInFormElement
        .querySelector("input[name='csrf_test_name']")!
        .attributes['value']!;
    String currentUrl = signInFormElement
        .querySelector("input[name='currentUrl']")!
        .attributes['value']!;
    const String loginUrl = 'https://belarasa.id/auth/login';
    Response<String> loginResponse = await post(
        loginUrl,
        {
          'email': email,
          'password': password,
          'csrf_test_name': csrfTestName,
          'currentUrl': currentUrl,
        },
        contentType: "application/x-www-form-urlencoded",
        headers: {
          'cookie': initialResponse.headers!['set-cookie']!,
        });
    CookieService cookieService = Get.find<CookieService>();
    String setCookieValue = loginResponse.headers!['set-cookie']!;
    String csrfCookieString =
        setCookieValue.substring(0, setCookieValue.indexOf("ci_session") - 1);
    String ciSessionString =
        setCookieValue.substring(setCookieValue.indexOf("ci_session"));
    List<Cookie> cookies = [
      Cookie.fromSetCookieValue(csrfCookieString),
      Cookie.fromSetCookieValue(ciSessionString),
    ];
    await cookieService.saveFromResponse(loginUrl, cookies);
    return loginResponse;
  }
}
