import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/restrr_impl.dart';

import 'entities/currency/currency_impl.dart';
import 'entities/currency/custom_currency_impl.dart';
import 'entities/session/partial_session_impl.dart';
import 'entities/session/session_impl.dart';
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

  PartialSession buildSession(Map<String, dynamic> json) {
    PartialSessionImpl session = PartialSessionImpl(
      api: api,
      id: json['id'],
      name: json['name'],
      expiredAt: DateTime.parse(json['expired_at']),
      user: buildUser(json['user']),
    );
    if (json['token'] != null) {
      session = SessionImpl(
        api: api,
        id: session.id,
        name: session.name,
        expiredAt: session.expiredAt,
        user: session.user,
        token: json['token'],
      );
    }
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
