import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../../restrr.dart';

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
