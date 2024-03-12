import 'package:restrr/src/service/api_service.dart';

import '../../restrr.dart';

class SessionService extends ApiService {
  const SessionService({required super.api});

  static Future<RestResponse<Session>> create(Uri uri, String username, String password, {String? sessionName}) async {
    return RequestHandler.request(
        route: SessionRoutes.create.compile(),
        body: {
          'username': username,
          'password': password,
          'session_name': sessionName,
        },
        mapper: (json) => EntityBuilder.buildSession(json),
        errorMap: {
          404: RestrrError.invalidCredentials,
          401: RestrrError.invalidCredentials,
        });
  }

  Future<RestResponse<bool>> logout() async {
    return noResponseRequest(route: SessionRoutes.deleteCurrent.compile(), errorMap: {
      401: RestrrError.notSignedIn,
    });
  }

}