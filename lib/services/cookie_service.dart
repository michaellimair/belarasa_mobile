import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';

class CookieService extends GetxService {
  late CookieJar _cookieJar;

  Future<CookieService> init() async {
    _cookieJar = CookieJar();
    return this;
  }

  Future<void> saveFromResponse(String url, List<Cookie> cookies) async {
    return _cookieJar.saveFromResponse(Uri.parse(url), cookies);
  }

  Future<void> saveFromRawResponse(String url, String setCookieValue) async {
    List<String> setCookieValues = setCookieValue.split(",");
    List<Cookie> cookies = setCookieValues.map((val) {
      return Cookie.fromSetCookieValue(setCookieValue);
    }).toList();
    return _cookieJar.saveFromResponse(Uri.parse(url), cookies);
  }

  Future<List<Cookie>> loadForRequest(String url) async {
    return _cookieJar.loadForRequest(Uri.parse(url));
  }

  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }

  Future<String> loadParsedForRequest(String url) async {
    List<Cookie> cookies = await loadForRequest(url);
    return cookies.map((c) => "${c.name}=${c.value}").join("; ");
  }
}
