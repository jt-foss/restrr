import '../../restrr.dart';

class UserService extends ApiService {
  const UserService({required super.api});

  Future<RestResponse<User>> login(String username, String password) async {
    return ApiService.request(
        route: UserRoutes.login.compile(),
        body: {
          'username': username,
          'password': password,
        },
        mapper: (json) => api.entityBuilder.buildUser(json));
  }

  Future<RestResponse<bool>> logout() async {
    return ApiService.noResponseRequest(route: UserRoutes.logout.compile());
  }

  Future<RestResponse<User>> getSelf() async {
    return ApiService.request(route: UserRoutes.me.compile(), mapper: (json) => api.entityBuilder.buildUser(json));
  }
}
