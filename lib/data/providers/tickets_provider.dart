import 'dart:convert';
import 'dart:io';

import 'package:belarasa_mobile/data/models/tickets_model.dart';
import 'package:belarasa_mobile/services/cookie_service.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class TicketsProvider extends GetConnect {
  List<TicketModel> ticketDecoder(dynamic content) {
    String bodyString = content as String;
    Document ticketDocument = parse(bodyString);
    List<Element> ticketsString = ticketDocument.querySelectorAll(
        "div.row.align-items-center.justify-content-md-center");
    return ticketsString
        .where((element) => element.querySelector("#invisible_form") != null)
        .map<TicketModel>((e) {
      final blocks = e
          .querySelector("div[style='line-height: 1.2;']")!
          .querySelectorAll("p");
      Element invisibleForm = e.querySelector("#invisible_form")!;
      return TicketModel(
        eventName: e
            .querySelector(".font-weight-bold.text-primary.mb-2.text-limit")!
            .innerHtml,
        diocese: blocks[0]
            .innerHtml
            .trim()
            .replaceAll(RegExp(' +'), ' ')
            .replaceAll("\n", ""),
        location: blocks[1]
            .innerHtml
            .trim()
            .replaceAll(RegExp(' +'), ' ')
            .replaceAll("\n", ""),
        churchName: blocks[2]
            .innerHtml
            .trim()
            .replaceAll(RegExp(' +'), ' ')
            .replaceAll("\n", ""),
        qrCodeUrl: e.querySelector(".img-fluid")!.attributes['src']!,
        registrantName: e.querySelector("p.font-weight-bold")!.innerHtml,
        userId: invisibleForm
            .querySelector("input[name='userId']")!
            .attributes['value']!,
        dafId: invisibleForm
            .querySelector("input[name='dafId']")!
            .attributes['value']!,
        userKK: invisibleForm
            .querySelector("input[name='userKK']")!
            .attributes['value']!,
        massId: invisibleForm
            .querySelector("input[name='misaId']")!
            .attributes['value']!,
        massDate: invisibleForm
            .querySelector("input[name='misa_tgl']")!
            .attributes['value']!,
        massDay: invisibleForm
            .querySelector("input[name='misa_hari']")!
            .attributes['value']!,
        massTime: invisibleForm
            .querySelector("input[name='misa_jam']")!
            .attributes['value']!,
        qrCodeFileName: invisibleForm
            .querySelector("input[name='qrcode']")!
            .attributes['value']!,
      );
    }).toList();
  }

  Future<Response<String>> showTicket(TicketModel ticket) async {
    const String showTicketUrl = "https://belarasa.id/xticket/showTicketMisa";
    CookieService cookieService = Get.find<CookieService>();
    String cookies = await cookieService.loadParsedForRequest(showTicketUrl);
    return post(
      showTicketUrl,
      {
        "userId": ticket.userId,
        "dafId": ticket.dafId,
        "userKK": ticket.userKK,
        "misaId": ticket.massId,
        "misa_tgl": ticket.massDate,
        "misa_hari": ticket.massDay,
        "misa_jam": ticket.massTime,
        "qrcode": ticket.qrCodeFileName,
      },
      headers: {
        "Cookie": cookies,
      },
      contentType: "application/x-www-form-urlencoded",
    );
  }

  Future<Response<Map<String, dynamic>>> resendTicket(TicketModel ticket) async {
    const String resendTicketUrl = "https://belarasa.id/xmisa/regenQR";
    CookieService cookieService = Get.find<CookieService>();
    List<Cookie> cookies = await cookieService.loadForRequest(resendTicketUrl);
    String csrfToken = cookies
        .firstWhere((element) => element.name == "csrf_cookie_name")
        .value;
    String cookieString =
        await cookieService.loadParsedForRequest(resendTicketUrl);
    return post(
      resendTicketUrl,
      {
        "daftar_misa_id": ticket.dafId,
        "csrf_test_name": csrfToken,
      },
      headers: {
        "Cookie": cookieString,
      },
      contentType: "application/x-www-form-urlencoded",
      decoder: (dynamic content) {
        return jsonDecode(content.toString());
      },
    );
  }

  Future<Response<List<TicketModel>>> listTickets() async {
    const String listTicketsUrl =
        'https://belarasa.id/ticket-misa/listTicketMisa';
    CookieService cookieService = Get.find<CookieService>();
    String cookies = await cookieService.loadParsedForRequest(listTicketsUrl);
    Response<List<TicketModel>> ticketsResponse = await get(listTicketsUrl,
        headers: {'cookie': cookies}, decoder: ticketDecoder);
    String setCookieValue = ticketsResponse.headers!['set-cookie']!;
    await cookieService.saveFromResponse(
        listTicketsUrl, [Cookie.fromSetCookieValue(setCookieValue)]);
    return ticketsResponse;
  }
}
