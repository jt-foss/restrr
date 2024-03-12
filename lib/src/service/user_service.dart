import '../../restrr.dart';
import 'api_service.dart';

class UserService extends ApiService {
  const UserService({required super.api});

  Future<RestResponse<User>> register(String username, String password, {String? email, String? displayName}) async {
    return request(
        route: UserRoutes.create.compile(),
        body: {
          'username': username,
          'password': password,
          if (email != null) 'email': email,
          if (displayName != null) 'display_name': displayName,
        },
        mapper: (json) => api.entityBuilder.buildUser(json),
        errorMap: {
          409: RestrrError.alreadySignedIn,
        });
  }

  Future<RestResponse<User>> getSelf() async {
    return request(route: UserRoutes.getSelf.compile(), mapper: (json) => api.entityBuilder.buildUser(json), errorMap: {
      401: RestrrError.notSignedIn,
    });
  }
}
