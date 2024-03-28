import '../../../../restrr.dart';

abstract class CurrencyId extends Id<Currency> {}

abstract class Currency extends RestrrEntity<Currency, CurrencyId> {
  @override
  CurrencyId get id;

  String get name;
  String get symbol;
  int get decimalPlaces;
  String? get isoCode;
}
