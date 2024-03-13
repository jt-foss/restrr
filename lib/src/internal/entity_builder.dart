import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/restrr_impl.dart';

import 'entities/currency_impl.dart';
import 'entities/server_info_impl.dart';
import 'entities/session_impl.dart';
import 'entities/user_impl.dart';

/// Defines how to build entities from JSON responses.
class EntityBuilder {
  final RestrrImpl api;

  const EntityBuilder({required this.api});

  static ServerInfo buildServerInfo(Map<String, dynamic> json) {
    return ServerInfoImpl(
      healthy: json['healthy'],
      apiVersion: json['api_version'],
      details: json.keys.contains('details') ? json['details'] : null,
    );
  }

  Currency buildCurrency(Map<String, dynamic> json) {
    final CurrencyImpl currency = CurrencyImpl(
      api: api,
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      isoCode: json['iso_code'],
      decimalPlaces: json['decimal_places'],
      user: json['user'],
    );
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
