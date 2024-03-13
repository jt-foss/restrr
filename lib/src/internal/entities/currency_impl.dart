import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

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

  @override
  bool get isCustom => user != null;

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
