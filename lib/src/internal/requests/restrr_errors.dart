import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/requests/responses/rest_response.dart';

enum RestrrError {
  unknown(              0xFFF0, 'Unknown error occurred'),
  internalServerError(  0xFFF1, 'Internal server error occurred'),
  serviceUnavailable(   0xFFF3, 'Service is unavailable'),

  invalidSession(       0x0001, 'Session expired or invalid!'),
  sessionLimitReached(  0x0002, 'Session limit reached!'),
  signedIn(             0x0003, 'User is signed in.'),
  invalidCredentials(   0x0004, 'Invalid credentials provided.'),
  resourceNotFound(     0x0005, 'Resource not found.'),
  unauthorized(         0x0006, 'Unauthorized.'),
  noTokenProvided(      0x0007, 'No token provided.'),
  ;

  final int code;
  final String message;

  const RestrrError(this.code, this.message);

  // TODO: replace this with status code in the future

  static RestrrError? fromStatusMessage(String message) {
    for (RestrrError value in RestrrError.values) {
      if (value.message == message) {
        return value;
      }
    }
    return null;
  }

  RestrrException toException() => ServerException(this);
  RestResponse<T> toResponse<T>({required int? statusCode}) => RestResponse<T>(error: toException(), statusCode: statusCode);
}