import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../../../restrr.dart';

class PartialSessionImpl extends RestrrEntityImpl implements PartialSession {
  @override
  final String? name;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  final User user;

  const PartialSessionImpl({
    required super.api,
    required super.id,
    required this.name,
    required this.createdAt,
    required this.expiresAt,
    required this.user,
  });

  @override
  Future<bool> delete() async {
    final response = await api.requestHandler.noResponseApiRequest(route: SessionRoutes.getById.compile(params: [id]));
    return response.hasData && response.data!;
  }
}
