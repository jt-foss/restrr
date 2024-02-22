import 'dart:math';

import 'package:restrr/restrr.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

final Uri _invalidUri = Uri.parse('https://financrr-stage.jasonlessenich.dev');
final Uri _validUri = Uri.parse('https://financrr-stage.denux.dev');

void main() {
  group('[RestrrBuilder] ', () {
    test('.login (invalid URL)', () async {
      final RestResponse<Restrr> response =
          await RestrrBuilder.login(uri: _invalidUri, username: '', password: '').create();
      expect(response.hasData, false);
      expect(response.error, RestrrError.invalidUri);
    });

    test('.login (invalid credentials)', () async {
      final RestResponse<Restrr> response =
          await RestrrBuilder.login(uri: _validUri, username: 'abc', password: 'abc').create();
      expect(response.hasData, false);
      expect(response.error, RestrrError.invalidCredentials);
    });

    test('.login (valid)', () async {
      final RestResponse<Restrr> response =
      await RestrrBuilder.login(uri: _validUri, username: 'admin', password: 'Financrr123').create();
      expect(response.hasData, true);
    });

    test('.register (bad request (password too short))', () async {
      final RestResponse<Restrr> response =
      await RestrrBuilder.register(uri: _validUri, username: 'jasonlessenich', password: 'Financrr123!').create();
      expect(response.hasData, false);
      expect(response.error, RestrrError.badRequest);
    });

    test('.register (already signed in)', () async {
      final RestResponse<Restrr> response =
      await RestrrBuilder.register(uri: _validUri, username: 'jasonlessenich', password: 'Financrr123567879!').create();
      expect(response.hasData, false);
      expect(response.error, RestrrError.alreadySignedIn);
    });
  });
}
