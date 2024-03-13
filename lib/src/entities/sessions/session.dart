import 'package:restrr/src/service/session_service.dart';

import '../../../restrr.dart';

abstract class Session implements RestrrEntity {
  String get token;
  String? get name;
  DateTime get expiredAt;
  User get user;
}

class SessionImpl extends RestrrEntityImpl implements Session {
  @override
  final String token;
  @override
  final String? name;
  @override
  final DateTime expiredAt;
  @override
  final User user;

  const SessionImpl({
    required super.api,
    required super.id,
    required this.token,
    required this.name,
    required this.expiredAt,
    required this.user,
  });
}
