import '../../../restrr.dart';
import '../restrr_impl.dart';

abstract class IdImpl<T> implements Id<T> {
  @override
  final RestrrImpl api;
  @override
  final IdPrimitive id;

  const IdImpl({required this.api, required this.id});
}

class RestrrEntityImpl<E, T extends Id<E>> implements RestrrEntity<E, T> {
  @override
  final RestrrImpl api;
  @override
  final T id;

  const RestrrEntityImpl({
    required this.api,
    required this.id,
  });
}
