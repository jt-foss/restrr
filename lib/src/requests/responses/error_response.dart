import 'package:restrr/restrr.dart';

/// Represents a type of error that can occur during a REST request.
enum RestrrError {
  invalidCredentials,
  alreadySignedIn,

  /* Client errors */

  noInternetConnection(clientError: true),
  serverUnreachable(clientError: true),
  invalidUri(clientError: true),
  unknown(clientError: true);

  final bool clientError;

  const RestrrError({this.clientError = false});

  RestResponse<T> toRestResponse<T>({int? statusCode}) {
    return ErrorResponse(type: this, statusCode: statusCode).toRestResponse(statusCode: statusCode);
  }
}

class ErrorResponse {
  final RestrrError type;
  final int? statusCode;

  const ErrorResponse({required this.type, this.statusCode});

  RestResponse<T> toRestResponse<T>({int? statusCode}) => RestResponse(error: this);
}
