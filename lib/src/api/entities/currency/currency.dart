import '../../../../restrr.dart';

abstract class Currency extends RestrrEntity {
  String get name;
  String get symbol;
  int get decimalPlaces;
  String? get isoCode;
}
