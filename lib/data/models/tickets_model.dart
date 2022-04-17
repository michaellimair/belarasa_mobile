import 'package:intl/intl.dart';

class TicketModel {
  String eventName;
  String location;
  String diocese;
  String churchName;
  String qrCodeUrl;
  String registrantName;

  String userId;
  String dafId;
  String userKK;
  String massId;
  String massDate;
  String massDay;
  String massTime;
  String qrCodeFileName;

  TicketModel({
    required this.eventName,
    required this.location,
    required this.diocese,
    required this.churchName,
    required this.qrCodeUrl,
    required this.registrantName,
    required this.userId,
    required this.dafId,
    required this.userKK,
    required this.massId,
    required this.massDate,
    required this.massDay,
    required this.massTime,
    required this.qrCodeFileName,
  });

  bool get isPastTicket {
    DateTime massDt = DateFormat("yyyy-MM-dd").parse(massDate).add(const Duration(days: 1)).subtract(const Duration(seconds: 1));
    DateTime nowDt = DateTime.now();
    return massDt.isBefore(nowDt);
  }
}
