import '../../../restrr.dart';

typedef IdPrimitive = int;

abstract class Id<T> {
  Restrr get api;
  IdPrimitive get id;

  T? get();
  Future<T> retrieve({forceRetrieve = false});
}

/// The base class for all Restrr entities.
/// This simply provides a reference to the Restrr instance.
abstract class RestrrEntity<E, T extends Id<E>> {
  /// A reference to the Restrr instance.
  Restrr get api;

  T get id;
}
