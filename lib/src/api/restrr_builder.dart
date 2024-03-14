import '../../restrr.dart';
import '../internal/requests/responses/rest_response.dart';
import '../internal/restrr_impl.dart';

/// A builder for creating a new [Restrr] instance.
/// The [Restrr] instance is created by calling [create].
class RestrrBuilder {
  final Map<Type, Function> _eventMap = {};

  final Uri uri;

  final RestrrOptions options;

  RestrrBuilder({required this.uri, this.options = const RestrrOptions()});

  RestrrBuilder on<T extends RestrrEvent>(Type type, void Function(T) func) {
    _eventMap[type] = func;
    return this;
  }

  Future<Restrr> login({required String username, required String password, String? sessionName}) async {
    return _handleAuthProcess(authFunction: (apiImpl) {
      return apiImpl.requestHandler.apiRequest(
          route: SessionRoutes.create.compile(),
          body: {
            'username': username,
            'password': password,
            'session_name': sessionName,
          },
          noAuth: true,
          mapper: (json) => apiImpl.entityBuilder.buildSession(json));
    });
  }

  Future<Restrr> refresh({required String sessionToken}) async {
    return _handleAuthProcess(authFunction: (apiImpl) {
      return apiImpl.requestHandler.apiRequest(
          route: SessionRoutes.refresh.compile(),
          bearerTokenOverride: sessionToken,
          mapper: (json) => apiImpl.entityBuilder.buildSession(json));
    });
  }

  Future<Restrr> _handleAuthProcess(
      {required Future<RestResponse<Session>> Function(RestrrImpl) authFunction}) async {
    // check if the URI is valid and the API is healthy
    final ServerInfo statusResponse = await Restrr.checkUri(uri, isWeb: options.isWeb);
    Restrr.log.config('Host: $uri, API v${statusResponse.apiVersion}');
    // build api instance
    final RestrrImpl apiImpl = RestrrImpl(
        options: options,
        routeOptions: RouteOptions(hostUri: uri, apiVersion: statusResponse.apiVersion),
        eventMap: _eventMap);
    // call auth function
    final RestResponse<Session> response = await authFunction(apiImpl);
    if (response.hasError) {
      throw response.error!;
    }
    apiImpl.session = response.data!;
    apiImpl.eventHandler.fire(ReadyEvent(api: apiImpl));
    return apiImpl;
  }
}
