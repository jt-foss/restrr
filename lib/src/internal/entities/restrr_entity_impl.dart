import '../../../restrr.dart';
import '../restrr_impl.dart';

abstract class IdImpl<E> implements Id<E> {
  @override
  final RestrrImpl api;
  @override
  final IdPrimitive id;

  const IdImpl({required this.api, required this.id});
}

class RestrrEntityImpl<E, ID extends Id<E>> implements RestrrEntity<E, ID> {
  @override
  final RestrrImpl api;
  @override
  final ID id;

  const RestrrEntityImpl({
    required this.api,
    required this.id,
  });
}
