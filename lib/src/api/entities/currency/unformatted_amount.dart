import 'package:restrr/restrr.dart';

class UnformattedAmount {
  static const UnformattedAmount zero = UnformattedAmount(0);

  final int rawAmount;

  const UnformattedAmount(this.rawAmount);

  /// Removes all non-digit characters from the string and parses the result as an integer.
  /// (e.g. '1,234.56€' -> 123456)
  static UnformattedAmount fromString(String str) {
    return UnformattedAmount(int.parse(str.replaceAll(RegExp(r'[^\d]'), '')));
  }

  static UnformattedAmount fromJson(dynamic json) {
    if (json == null || json is! int) {
      throw ArgumentError.value(json, 'json', 'Invalid JSON value for UnformattedCurrencyAmount. Expected an integer.');
    }
    return UnformattedAmount(json);
  }

  String format(int decimalPlaces, String decimalSeparator,
      {String? currencySymbol, String? thousandsSeparator, bool isNegative = false}) {
    // whether the amount is negative by itself or the user defined it to be negative
    bool negativeAmount = rawAmount < 0 || isNegative;
    String amount = rawAmount.toString();
    // remove sign
    if (negativeAmount) {
      amount = amount.substring(1);
    }
    if (amount.length <= decimalPlaces) {
      amount = '0'.padLeft(decimalPlaces - amount.length + 1, '0') + amount;
    }
    amount =
        amount.substring(0, amount.length - decimalPlaces) + decimalSeparator + amount.substring(amount.length - decimalPlaces);
    if (thousandsSeparator != null) {
      for (int i = amount.length - decimalPlaces - 4; i > 0; i -= 3) {
        amount = amount.substring(0, i) + thousandsSeparator + amount.substring(i);
      }
    }
    return '${negativeAmount ? '-' : ''}$amount${currencySymbol ?? ''}';
  }

  String formatWithCurrency(Currency currency, String decimalSeparator, {String? thousandsSeparator, bool isNegative = false}) {
    return format(currency.decimalPlaces, decimalSeparator,
        currencySymbol: currency.symbol, thousandsSeparator: thousandsSeparator, isNegative: isNegative);
  }

  @override
  UnformattedAmount operator +(UnformattedAmount other) => UnformattedAmount(rawAmount + other.rawAmount);

  @override
  UnformattedAmount operator -(UnformattedAmount other) => UnformattedAmount(rawAmount - other.rawAmount);

  @override
  UnformattedAmount operator *(int other) => UnformattedAmount(rawAmount * other);

  @override
  UnformattedAmount operator /(int other) => UnformattedAmount(rawAmount ~/ other);

  @override
  bool operator ==(Object other) => other is UnformattedAmount && rawAmount == other.rawAmount;

  @override
  bool operator <(UnformattedAmount other) => rawAmount < other.rawAmount;

  @override
  bool operator <=(UnformattedAmount other) => rawAmount <= other.rawAmount;

  @override
  bool operator >(UnformattedAmount other) => rawAmount > other.rawAmount;

  @override
  bool operator >=(UnformattedAmount other) => rawAmount >= other.rawAmount;

  @override
  String toString() => rawAmount.toString();
}
