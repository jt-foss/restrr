import 'package:dio/dio.dart';
import 'package:restrr/src/internal/requests/responses/paginated_response.dart';
import 'package:restrr/src/internal/requests/responses/rest_response.dart';
import 'package:restrr/src/api/requests/route.dart';

import '../../../restrr.dart';
import 'restrr_errors.dart';

/// Utility class for handling requests.
class RequestHandler {
  const RequestHandler._();

  /// Tries to execute a request, using the [CompiledRoute] and maps the received data using the
  /// specified [mapper] function, ultimately returning the entity in an [RestResponse].
  ///
  /// If this fails, this will return an [RestResponse] containing an error.
  static Future<RestResponse<T>> request<T>(
      {required CompiledRoute route,
        required T Function(dynamic) mapper,
        required RouteOptions routeOptions,
        String? bearerToken,
        Map<int, RestrrError> errorMap = const {},
        dynamic body,
        String contentType = 'application/json'}) async {
    try {
      final Response<dynamic> response = await route.submit(
          routeOptions: routeOptions, body: body, bearerToken: bearerToken, contentType: contentType);
      return RestResponse(data: mapper.call(response.data), statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e, errorMap);
    }
  }

  /// Tries to execute a request, using the [CompiledRoute], without expecting any response.
  ///
  /// If this fails, this will return an [RestResponse] containing an error.
  static Future<RestResponse<bool>> noResponseRequest<T>(
      {required CompiledRoute route,
        required RouteOptions routeOptions,
        String? bearerToken,
        dynamic body,
        Map<int, RestrrError> errorMap = const {},
        String contentType = 'application/json'}) async {
    try {
      final Response<dynamic> response = await route.submit(
          routeOptions: routeOptions, body: body, bearerToken: bearerToken, contentType: contentType);
      return RestResponse(data: true, statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e, errorMap);
    }
  }

  /// Tries to execute a request, using the [CompiledRoute] and maps the received list of data using the
  /// specified [mapper] function, ultimately returning the list of entities in an [RestResponse].
  ///
  /// If this fails, this will return an [RestResponse] containing an error.
  static Future<RestResponse<List<T>>> multiRequest<T>(
      {required CompiledRoute route,
        required RouteOptions routeOptions,
        String? bearerToken,
        required T Function(dynamic) mapper,
        Map<int, RestrrError> errorMap = const {},
        dynamic body,
        String contentType = 'application/json'}) async {
    try {
      final Response<dynamic> response = await route.submit(
          routeOptions: routeOptions, body: body, bearerToken: bearerToken, contentType: contentType);
      if (response.data is! List<dynamic>) {
        throw StateError('Received response is not a list!');
      }
      return RestResponse(
          data: (response.data as List<dynamic>).map((single) => mapper.call(single)).toList(),
          statusCode: response.statusCode);
    } on DioException catch (e) {
      return _handleDioException(e, errorMap);
    }
  }

  static Future<RestResponse<List<T>>> paginatedRequest<T>(
      {required CompiledRoute route,
        required RouteOptions routeOptions,
        String? bearerToken,
        required T Function(dynamic) mapper,
        Map<int, RestrrError> errorMap = const {},
        dynamic body,
        String contentType = 'application/json'}) async {
    try {
      final Response<dynamic> response = await route.submit(
          routeOptions: routeOptions, body: body, bearerToken: bearerToken, contentType: contentType);
      if (response.data['data'] is! List<dynamic>) {
        throw StateError('Received response is not a list!');
      }
      return PaginatedResponse(
          metadata: PaginatedResponseMetadata.fromJson(response.data['_metadata']),
          data: (response.data['data'] as List<dynamic>).map((single) => mapper.call(single)).toList(),
          statusCode: response.statusCode
      );
    } on DioException catch (e) {
      return _handleDioException(e, errorMap);
    }
  }

  static Future<RestResponse<T>> _handleDioException<T>(DioException ex, Map<int, RestrrError> errorMap) async {
    // check status code
    final int? statusCode = ex.response?.statusCode;
    if (statusCode != null) {
      if (errorMap.containsKey(statusCode)) {
        return _errorToRestResponse(errorMap[statusCode]!, statusCode: statusCode);
      }
      final RestrrError? err = switch (statusCode) {
        400 => RestrrError.badRequest,
        500 => RestrrError.internalServerError,
        503 => RestrrError.serviceUnavailable,
        _ => null
      };
      if (err != null) {
        return _errorToRestResponse(err, statusCode: statusCode);
      }
    }
    // check timeout
    if (ex.type == DioExceptionType.connectionTimeout || ex.type == DioExceptionType.receiveTimeout) {
      return _errorToRestResponse(RestrrError.serverUnreachable, statusCode: statusCode);
    }
    Restrr.log.warning('Unknown error occurred: ${ex.message}, ${ex.stackTrace}');
    return _errorToRestResponse(RestrrError.unknown, statusCode: statusCode);
  }

  static RestResponse<T> _errorToRestResponse<T>(RestrrError error, {int? statusCode}) {
    return RestResponse(error: error, statusCode: statusCode);
  }
}