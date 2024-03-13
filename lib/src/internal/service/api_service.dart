import 'dart:async';

import 'package:logging/logging.dart';
import 'package:restrr/restrr.dart';

import '../../api/requests/route.dart';

/// A service that provides methods to interact with the API.
abstract class ApiService {
  final Restrr api;

  const ApiService({required this.api});

  Future<RestResponse<T>> request<T>(
      {required CompiledRoute route,
      required T Function(dynamic) mapper,
      String? customBearerToken,
      bool noAuth = false,
      Map<int, RestrrError> errorMap = const {},
      dynamic body,
      String contentType = 'application/json'}) async {
    return RequestHandler.request(
            route: route,
            routeOptions: api.routeOptions,
            isWeb: api.options.isWeb,
            bearerToken: customBearerToken ?? (noAuth ? null : api.session.token),
            mapper: mapper,
            errorMap: errorMap,
            body: body,
            contentType: contentType)
        .then((response) => _fireEvent(route, response));
  }

  Future<RestResponse<bool>> noResponseRequest<T>(
      {required CompiledRoute route,
      String? customBearerToken,
      bool noAuth = false,
      dynamic body,
      Map<int, RestrrError> errorMap = const {},
      String contentType = 'application/json'}) async {
    return RequestHandler.noResponseRequest(
            route: route,
            routeOptions: api.routeOptions,
            isWeb: api.options.isWeb,
            bearerToken: customBearerToken ?? (noAuth ? null : api.session.token),
            body: body,
            errorMap: errorMap,
            contentType: contentType)
        .then((response) => _fireEvent(route, response));
  }

  Future<RestResponse<List<T>>> multiRequest<T>(
      {required CompiledRoute route,
      required T Function(dynamic) mapper,
      String? customBearerToken,
      bool noAuth = false,
      Map<int, RestrrError> errorMap = const {},
      dynamic body,
      String contentType = 'application/json'}) async {
    return RequestHandler.multiRequest(
            route: route,
            routeOptions: api.routeOptions,
            isWeb: api.options.isWeb,
            bearerToken: customBearerToken ?? (noAuth ? null : api.session.token),
            mapper: mapper,
            errorMap: errorMap,
            body: body,
            contentType: contentType)
        .then((response) => _fireEvent(route, response));
  }

  Future<RestResponse<List<T>>> paginatedRequest<T>(
      {required CompiledRoute route,
        required T Function(dynamic) mapper,
        String? customBearerToken,
        bool noAuth = false,
        Map<int, RestrrError> errorMap = const {},
        dynamic body,
        String contentType = 'application/json'}) async {
    return RequestHandler.paginatedRequest(
        route: route,
        routeOptions: api.routeOptions,
        isWeb: api.options.isWeb,
        bearerToken: customBearerToken ?? (noAuth ? null : api.session.token),
        mapper: mapper,
        errorMap: errorMap,
        body: body,
        contentType: contentType)
        .then((response) => _fireEvent(route, response));
  }

  Future<RestResponse<T>> _fireEvent<T>(CompiledRoute route, RestResponse<T> response) async {
    if (!api.options.disableLogging) {
      Restrr.log.log(
          response.statusCode != null && response.statusCode! >= 400 ? Level.WARNING : Level.INFO,
          '[${DateTime.now().toIso8601String()}] ${route.baseRoute.method} '
          '${api.routeOptions.hostUri}${route.baseRoute.isVersioned ? '/api/v${api.routeOptions.apiVersion}' : ''}'
          '${route.compiledRoute} => ${response.statusCode} (${response.hasData ? 'OK' : response.error?.name})');
    }
    api.eventHandler.fire(RequestEvent(api: api, route: route.compiledRoute, statusCode: response.statusCode));
    return response;
  }
}
