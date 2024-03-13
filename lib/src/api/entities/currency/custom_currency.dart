import 'package:restrr/restrr.dart';

abstract class CustomCurrency extends Currency {
  int? get user;

  bool isCreatedBy(User user);

  Future<bool> delete();

  Future<Currency?> update({String? name, String? symbol, String? isoCode, int? decimalPlaces});
}
