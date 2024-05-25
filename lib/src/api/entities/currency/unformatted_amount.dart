import 'package:restrr/restrr.dart';

class UnformattedAmount {
  final int rawAmount;

  const UnformattedAmount(this.rawAmount);

  static UnformattedAmount fromJson(dynamic json) {
    if (json == null || json is! int) {
      throw ArgumentError.value(json, 'json', 'Invalid JSON value for UnformattedCurrencyAmount. Expected an integer.');
    }
    return UnformattedAmount(json);
  }

  String format(String currencySymbol, int decimalPlaces, String decimalSeparator, String thousandsSeparator) {
    return '';
  }

  String formatWithCurrency(Currency currency, String decimalSeparator, String thousandsSeparator) {
    return format(currency.symbol, currency.decimalPlaces, decimalSeparator, thousandsSeparator);
  }
}
