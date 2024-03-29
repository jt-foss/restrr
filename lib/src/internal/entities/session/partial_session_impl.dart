import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';
import 'package:restrr/src/internal/requests/responses/rest_response.dart';

import '../../../../restrr.dart';
import '../../utils/request_utils.dart';

class PartialSessionIdImpl extends IdImpl<PartialSession> implements PartialSessionId {
  const PartialSessionIdImpl({required super.api, required super.value});

  @override
  PartialSession? get() {
    return api.sessionCache.get(value);
  }

  @override
  Future<PartialSession> retrieve({forceRetrieve = false}) {
    return RequestUtils.getOrRetrieveSingle(
        key: this,
        cacheView: api.sessionCache,
        compiledRoute: SessionRoutes.getById.compile(params: [value]),
        mapper: (json) => api.entityBuilder.buildSession(json),
        forceRetrieve: forceRetrieve);
  }
}

class PartialSessionImpl extends RestrrEntityImpl<PartialSession, PartialSessionId> implements PartialSession {
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
    final RestResponse<bool> response =
        await api.requestHandler.noResponseApiRequest(route: SessionRoutes.deleteById.compile(params: [id.value]));
    return response.hasData && response.data!;
  }
}
