import 'package:restrr/src/internal/requests/restrr_errors.dart';

class ErrorResponse {
  final String details;
  final String? reference;
  final RestrrError? error;

  ErrorResponse({
    required this.details,
    required this.reference,
    required this.error,
  });

  static ErrorResponse? tryFromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty || json['details'] == null) {
      return null;
    }
    final RestrrError? error = RestrrError.fromStatusMessage(json['details']);
    return ErrorResponse(
      details: json['details'],
      reference: json['reference'],
      error: error,
    );
  }
}
