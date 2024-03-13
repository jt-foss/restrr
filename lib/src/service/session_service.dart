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
        mapper: (json) => api.entityBuilder.buildSession(json),
        errorMap: {
          404: RestrrError.invalidCredentials,
          401: RestrrError.invalidCredentials,
        });
  }

  Future<RestResponse<Session>> refresh() async {
    return request(
        route: SessionRoutes.create.compile(),
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
