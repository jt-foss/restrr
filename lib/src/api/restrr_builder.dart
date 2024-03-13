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

  Future<RestResponse<Restrr>> login({required String username, required String password, String? sessionName}) async {
    return _handleAuthProcess(authFunction: (apiImpl) {
      return apiImpl.requestHandler.apiRequest(
          route: SessionRoutes.create.compile(),
          body: {
            'username': username,
            'password': password,
            'session_name': sessionName,
          },
          noAuth: true,
          mapper: (json) => apiImpl.entityBuilder.buildSession(json),
          errorMap: {
            404: RestrrError.invalidCredentials,
            401: RestrrError.invalidCredentials,
          });
    });
  }

  Future<RestResponse<Restrr>> refresh({required String sessionToken}) async {
    return _handleAuthProcess(authFunction: (apiImpl) {
      return apiImpl.requestHandler.apiRequest(
          route: SessionRoutes.refresh.compile(),
          bearerTokenOverride: sessionToken,
          mapper: (json) => apiImpl.entityBuilder.buildSession(json),
          errorMap: {
            404: RestrrError.invalidCredentials,
            401: RestrrError.invalidCredentials,
          });
    });
  }

  Future<RestResponse<Restrr>> _handleAuthProcess(
      {required Future<RestResponse<Session>> Function(RestrrImpl) authFunction}) async {
    // check if the URI is valid and the API is healthy
    final RestResponse<ServerInfo> statusResponse = await Restrr.checkUri(uri, isWeb: options.isWeb);
    if (statusResponse.hasError) {
      Restrr.log.warning('Invalid financrr URI: $uri');
      return (statusResponse.error == RestrrError.unknown
              ? RestrrError.invalidUri
              : statusResponse.error ?? RestrrError.invalidUri)
          .toRestResponse(statusCode: statusResponse.statusCode);
    }
    Restrr.log.config('Host: $uri, API v${statusResponse.data!.apiVersion}');
    // build api instance
    final RestrrImpl apiImpl = RestrrImpl(
        options: options,
        routeOptions: RouteOptions(hostUri: uri, apiVersion: statusResponse.data!.apiVersion),
        eventMap: _eventMap);
    // call auth function
    final RestResponse<Session> response = await authFunction(apiImpl);
    if (response.hasError) {
      return response.error?.toRestResponse(statusCode: response.statusCode) ?? RestrrError.unknown.toRestResponse();
    }
    apiImpl.session = response.data!;
    apiImpl.eventHandler.fire(ReadyEvent(api: apiImpl));
    return RestResponse(data: apiImpl, statusCode: response.statusCode);
  }
}
