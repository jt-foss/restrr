import 'package:restrr/restrr.dart';

import 'currency_impl.dart';

class CustomCurrencyImpl extends CurrencyImpl implements CustomCurrency {
  @override
  final int? user;

  const CustomCurrencyImpl({
    required super.api,
    required super.id,
    required super.name,
    required super.symbol,
    required super.isoCode,
    required super.decimalPlaces,
    required this.user,
  });

  @override
  bool isCreatedBy(User user) => this.user == user.id;

  @override
  Future<bool> delete() {
    return api.deleteCurrencyById(id);
  }

  @override
  Future<Currency?> update({String? name, String? symbol, String? isoCode, int? decimalPlaces}) {
    return api.updateCurrencyById(id, name: name, symbol: symbol, isoCode: isoCode, decimalPlaces: decimalPlaces);
  }
}
