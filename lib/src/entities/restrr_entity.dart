import '../../restrr.dart';

typedef Id = int;

/// The base class for all Restrr entities.
/// This simply provides a reference to the Restrr instance.
abstract class RestrrEntity {
  /// A reference to the Restrr instance.
  Restrr get api;

  Id get id;
}

class RestrrEntityImpl implements RestrrEntity {
  @override
  final Restrr api;
  @override
  final Id id;

  const RestrrEntityImpl({
    required this.api,
    required this.id,
  });
}
