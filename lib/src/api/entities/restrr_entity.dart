import '../../../restrr.dart';

typedef IdPrimitive = int;

abstract class Id<E> {
  Restrr get api;
  IdPrimitive get id;

  E? get();
  Future<E> retrieve({forceRetrieve = false});
}

/// The base class for all Restrr entities.
/// This simply provides a reference to the Restrr instance.
abstract class RestrrEntity<E, ID extends Id<E>> {
  /// A reference to the Restrr instance.
  Restrr get api;

  ID get id;
}
