import 'dart:io';

import 'package:belarasa_mobile/data/models/mass_model.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class MassesProvider extends GetConnect {
  List<MassModel> massDecoder(dynamic content) {
    String bodyString = content as String;
    Document ticketDocument = parse(bodyString);
    List<Element> massesString = ticketDocument
        .querySelectorAll("div.col-md-4.ftco-animate.fadeInUp.ftco-animated");
    return massesString
        .where((element) =>
            element.querySelector(
                "h3.font-weight-bold.text-primary.mt-3.text-limit") !=
            null)
        .map<MassModel>((e) {
      Element pricingBlock = e.querySelector("ul.pricing-text")!;
      List<Element> blocks = pricingBlock.querySelectorAll("li");
      String date = blocks[0].text;
      String time = blocks[1].text;
      String parish = blocks[2].text;
      String region = blocks[3].text;
      String neighborhood = blocks[4].text;
      String territory = blocks[5].text;
      String churchName = blocks[6].text;
      Element massLinkElement = e.querySelector("a")!;
      String massLink = massLinkElement.attributes['href']!;
      Uri massUri = Uri.parse(massLink);
      int? remainingQuota =
          int.tryParse(e.querySelector("h3.m-0.font-weight-bold")!.text);
      String? targetAudienceString =
          e.querySelector("button.btn.btn-lg.mb-2.ml-0")?.text;
      MassTargetAudience? targetAudience = targetAudienceString != null
          ? MassTargetAudienceParser.parse(targetAudienceString)
          : null;
      return MassModel(
        eventName: e
            .querySelector("h3.font-weight-bold.text-primary.mt-3.text-limit")!
            .text,
        massId: massUri.queryParameters['misa_id'],
        dioceseId: massUri.queryParameters['keuskupan_id'],
        parishId: massUri.queryParameters['paroki_id'],
        date: date,
        time: time,
        region: region,
        parish: parish,
        neighborhood: neighborhood,
        territory: territory,
        churchName: churchName,
        remainingQuota: remainingQuota,
        targetAudience: targetAudience,
      );
    }).toList();
  }

  Future<Response<List<MassModel>>> listMasses() async {
    const String listMassesUrl = 'https://belarasa.id/xmisa/AllMisaParokiSaya';
    CookieService cookieService = Get.find<CookieService>();
    String cookies = await cookieService.loadParsedForRequest(listMassesUrl);
    Response<List<MassModel>> massesResponse = await get(listMassesUrl,
        headers: {'cookie': cookies}, decoder: massDecoder);
    String setCookieValue = massesResponse.headers!['set-cookie']!;
    await cookieService.saveFromResponse(
        listMassesUrl, [Cookie.fromSetCookieValue(setCookieValue)]);
    return massesResponse;
  }
}
