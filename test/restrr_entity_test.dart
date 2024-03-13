import 'dart:convert';

import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/restrr_impl.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

final Uri _validUri = Uri.parse('https://financrr-stage.denux.dev');

const String healthJson = '''
{
  "healthy": true,
  "api_version": 1,
  "details": null
}
''';

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

void main() {
  late RestrrImpl api;

  setUp(() async {
    // log in, get api instance
    api = (await RestrrBuilder(uri: _validUri).login(username: 'admin', password: 'Financrr123')).data! as RestrrImpl;
  });

  group('[EntityBuilder] ', () {
    test('.buildHealthResponse', () {
      final ServerInfo healthResponse = ServerInfo.fromJson(jsonDecode(healthJson));
      expect(healthResponse.healthy, true);
      expect(healthResponse.apiVersion, 1);
      expect(healthResponse.details, null);
    });

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
  });
}
