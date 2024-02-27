import 'package:restrr/restrr.dart';

abstract class Currency implements RestrrEntity {
  String get name;
  String get symbol;
  String get isoCode;
  int get decimalPlaces;
  int? get user;
}

class CurrencyImpl extends RestrrEntityImpl implements Currency {
  @override
  final String name;
  @override
  final String symbol;
  @override
  final String isoCode;
  @override
  final int decimalPlaces;
  @override
  final int? user;

  const CurrencyImpl({
    required super.api,
    required super.id,
    required this.name,
    required this.symbol,
    required this.isoCode,
    required this.decimalPlaces,
    required this.user,
  });
}
