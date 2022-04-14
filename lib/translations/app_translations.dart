import 'package:belarasa_mobile/translations/en_US/en_us_translations.dart';
import 'package:belarasa_mobile/translations/id_ID/id_id_translations.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en_US' : enUs,
    'id_ID': idID,
  };
}
