import 'package:restrr/src/service/api_service.dart';

import '../../restrr.dart';
import '../entities/user.dart';

class UserService extends ApiService {
  const UserService({required super.api});

  static Future<RestResponse<bool>> login(
      String username, String password) async {
    return ApiService.noResponseRequest(
        route: UserRoutes.login.compile(),
        body: {
          'username': username,
          'password': password,
        });
  }

  static Future<RestResponse<User>> getSelf() async {
    return ApiService.request(
        route: UserRoutes.me.compile(),
        mapper: (json) => EntityBuilder.buildUser(json));
  }
}
