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

  @override
  Future<bool> delete() async {
    final response = await api.requestHandler.noResponseApiRequest(route: SessionRoutes.getById.compile(params: [id]));
    return response.hasData && response.data!;
  }
}
