import 'package:restrr/src/service/api_service.dart';

import '../../restrr.dart';

class SessionService extends ApiService {
  const SessionService({required super.api});

  Future<RestResponse<Session>> create(String username, String password, {String? sessionName}) async {
    return request(
        route: SessionRoutes.create.compile(),
        body: {
          'username': username,
          'password': password,
          'session_name': sessionName,
        },
        noAuth: true,
        mapper: (json) => api.entityBuilder.buildSession(json),
        errorMap: {
          404: RestrrError.invalidCredentials,
          401: RestrrError.invalidCredentials,
        });
  }

  Future<RestResponse<Session>> refresh(String sessionToken) async {
    return request(
        route: SessionRoutes.refresh.compile(),
        customBearerToken: sessionToken,
        mapper: (json) => api.entityBuilder.buildSession(json),
        errorMap: {
          404: RestrrError.invalidCredentials,
          401: RestrrError.invalidCredentials,
        });
  }

  Future<RestResponse<bool>> delete() async {
    return noResponseRequest(route: SessionRoutes.deleteCurrent.compile(), errorMap: {
      401: RestrrError.notSignedIn,
    });
  }
}
