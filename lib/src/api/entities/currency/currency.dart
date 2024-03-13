import '../../../../restrr.dart';

abstract class Currency extends RestrrEntity {
  String get name;
  String get symbol;
  String get isoCode;
  int get decimalPlaces;
}