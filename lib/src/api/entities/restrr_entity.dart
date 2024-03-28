import '../../../restrr.dart';

typedef Id = int;

abstract class EntityId<E> {
  Restrr get api;
  Id get id;

  E? get();
  Future<E> retrieve({forceRetrieve = false});
}

/// The base class for all Restrr entities.
/// This simply provides a reference to the Restrr instance.
abstract class RestrrEntity<E, ID extends EntityId<E>> {
  /// A reference to the Restrr instance.
  Restrr get api;

  ID get id;
}
