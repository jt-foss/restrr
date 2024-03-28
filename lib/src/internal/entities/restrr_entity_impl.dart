import '../../../restrr.dart';
import '../restrr_impl.dart';

abstract class IdImpl<E> implements EntityId<E> {
  @override
  final RestrrImpl api;
  @override
  final Id id;

  const IdImpl({required this.api, required this.id});
}

class RestrrEntityImpl<E, ID extends EntityId<E>> implements RestrrEntity<E, ID> {
  @override
  final RestrrImpl api;
  @override
  final ID id;

  const RestrrEntityImpl({
    required this.api,
    required this.id,
  });
}
