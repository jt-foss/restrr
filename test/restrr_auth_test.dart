
import 'package:restrr/restrr.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

final Uri _invalidUri = Uri.parse('https://financrr-stage.jasonlessenich.dev');
final Uri _validUri = Uri.parse('https://financrr-stage.denux.dev');

void main() {
  late Restrr api;
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

    test('.login', () async {
      final RestResponse<Restrr> response =
      await RestrrBuilder.login(uri: _validUri, username: 'admin', password: 'Financrr123').create();
      expect(response.hasData, true);
      api = response.data!;
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

  group('[Restrr] ', () {
    test('.logout', () async {
      final bool response = await api.logout();
      expect(response, true);
    });

    test('.logout (not signed in)', () async {
      final bool response = await api.logout();
      expect(response, false);
    });
  });

  group('[UserService] ', () {
    test('.getSelf (not signed in)', () async {
      final RestResponse<User> response = await UserService(api: api).getSelf();
      expect(response.hasData, false);
      expect(response.error, RestrrError.notSignedIn);
    });
  });
}
