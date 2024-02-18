import 'package:restrr/restrr.dart';

class EntityBuilder {
  final RestrrImpl api;

  const EntityBuilder({required this.api});

  static HealthResponse buildHealthResponse(Map<String, dynamic> json) {
    return HealthResponseImpl(
      healthy: json['healthy'],
      apiVersion: json['api_version'],
      details: json.keys.contains('details') ? json['details'] : null,
    );
  }

  static User buildUser(Map<String, dynamic> json) {
    Restrr.log.info(json);
    return UserImpl(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: DateTime.parse(json['created_at']),
      isAdmin: json['is_admin'],
    );
  }
}
