import 'dart:convert';

import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/restrr_impl.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

final Uri _validUri = Uri.parse('https://api-stage.financrr.app');

const String userJson = '''
{
  "id": 1,
  "username": "admin",
  "email": null,
  "created_at": "+002024-02-17T20:48:43.391176000Z",
  "is_admin": true
}
''';

const String currencyJson = '''
{
  "id": 1,
  "name": "US Dollar",
  "symbol": "\$",
  "iso_code": "USD",
  "decimal_places": 2,
  "user": 1
}
''';

const String sessionJson = '''
{
  "id": 1,
  "token": "abc",
  "user": $userJson,
  "expired_at": "+002024-02-17T20:48:43.391176000Z"
}
''';

void main() {
  late RestrrImpl api;

  setUp(() async {
    // log in, get api instance
    api = (await RestrrBuilder(uri: _validUri).login(username: 'admin', password: 'Financrr123')) as RestrrImpl;
  });

  group('[EntityBuilder] ', () {
    test('.buildUser', () async {
      final User user = api.entityBuilder.buildUser(jsonDecode(userJson));
      expect(user.id, 1);
      expect(user.username, 'admin');
      expect(user.email, null);
      expect(user.createdAt, DateTime.parse('+002024-02-17T20:48:43.391176000Z'));
      expect(user.isAdmin, true);
    });

    test('.buildCurrency', () {
      final Currency currency = api.entityBuilder.buildCurrency(jsonDecode(currencyJson));
      expect(currency.id, 1);
      expect(currency.name, 'US Dollar');
      expect(currency.symbol, '\$');
      expect(currency.isoCode, 'USD');
      expect(currency.decimalPlaces, 2);
    });

    test('.buildSession', () {
      final Session session = api.entityBuilder.buildSession(jsonDecode(sessionJson)) as Session;
      expect(session.id, 1);
      expect(session.token, 'abc');
      expect(session.user.id, 1);
      expect(session.expiredAt, DateTime.parse('+002024-02-17T20:48:43.391176000Z'));
    });
  });
}
