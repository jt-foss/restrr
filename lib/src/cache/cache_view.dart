import 'package:restrr/restrr.dart';

class RestrrEntityCacheView<T extends RestrrEntity> {
  final Map<Id, T> _cache = {};

  T? get(Id id) => _cache[id];

  T cache(T value) => _cache[value.id] = value;

  T? remove(Id id) => _cache.remove(id);

  void clear() => _cache.clear();

  bool contains(Id id) => _cache.containsKey(id);
}
