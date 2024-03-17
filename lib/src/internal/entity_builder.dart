import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/restrr_impl.dart';

import 'entities/currency/currency_impl.dart';
import 'entities/currency/custom_currency_impl.dart';
import 'entities/session_impl.dart';
import 'entities/user_impl.dart';

/// Defines how to build entities from JSON responses.
class EntityBuilder {
  final RestrrImpl api;

  const EntityBuilder({required this.api});

  Currency buildCurrency(Map<String, dynamic> json) {
    CurrencyImpl currency = CurrencyImpl(
      api: api,
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      decimalPlaces: json['decimal_places'],
      isoCode: json['iso_code'],
    );
    // check if user is present
    // if so, this must be a custom currency
    if (json['user'] != null) {
      currency = CustomCurrencyImpl(
        api: api,
        id: currency.id,
        name: currency.name,
        symbol: currency.symbol,
        isoCode: currency.isoCode,
        decimalPlaces: currency.decimalPlaces,
        user: json['user'],
      );
    }
    return api.currencyCache.cache(currency);
  }

  Session buildSession(Map<String, dynamic> json) {
    final SessionImpl session = SessionImpl(
      api: api,
      id: json['id'],
      token: json['token'],
      name: json['name'],
      expiredAt: DateTime.parse(json['expired_at']),
      user: buildUser(json['user']),
    );
    return session;
  }

  User buildUser(Map<String, dynamic> json) {
    final UserImpl user = UserImpl(
      api: api,
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['display_name'],
      createdAt: DateTime.parse(json['created_at']),
      isAdmin: json['is_admin'],
    );
    return api.userCache.cache(user);
  }
}
