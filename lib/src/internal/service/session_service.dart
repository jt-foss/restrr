import 'package:restrr/src/service/api_service.dart';

import '../../restrr.dart';

class SessionService extends ApiService {
  const SessionService({required super.api});

  Future<RestResponse<Session>> retrieveCurrent() async {
    return request(
        route: SessionRoutes.getCurrent.compile(),
        mapper: (json) => api.entityBuilder.buildSession(json),
        errorMap: {
          401: RestrrError.invalidCredentials,
          404: RestrrError.notSignedIn,
        });
  }

  Future<RestResponse<bool>> deleteCurrent() async {
    return noResponseRequest(route: SessionRoutes.deleteCurrent.compile(), errorMap: {
      401: RestrrError.notSignedIn,
    });
  }

  Future<RestResponse<Session>> retrieveById(Id id) async {
    return request(
        route: SessionRoutes.getById.compile(params: [id]),
        mapper: (json) => api.entityBuilder.buildSession(json),
        errorMap: {
          401: RestrrError.invalidCredentials,
          404: RestrrError.notFound,
        });
  }

  Future<RestResponse<bool>> deleteById(Id id) async {
    return noResponseRequest(
        route: SessionRoutes.deleteById.compile(params: [id]),
        errorMap: {
          401: RestrrError.invalidCredentials,
          404: RestrrError.notFound,
        });
  }

  Future<RestResponse<List<Session>>> retrieveAll() async {
    return paginatedRequest(
        route: SessionRoutes.getAll.compile(),
        mapper: (json) => api.entityBuilder.buildSession(json),
        errorMap: {
          401: RestrrError.invalidCredentials,
          404: RestrrError.notFound,
        });
  }

  Future<RestResponse<bool>> deleteAll() async {
    return noResponseRequest(
        route: SessionRoutes.deleteAll.compile(),
        errorMap: {
          401: RestrrError.invalidCredentials,
          404: RestrrError.notFound,
        });
  }

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
}
