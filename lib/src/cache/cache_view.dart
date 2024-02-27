import 'package:restrr/restrr.dart';

class RestrrEntityCacheView<T extends RestrrEntity> {
  final Map<int, T> _cache = {};

  T? get(int id) => _cache[id];

  T add(T value) => _cache[value.id] = value;

  T? remove(int id) => _cache.remove(id);

  void clear() => _cache.clear();

  bool contains(int id) => _cache.containsKey(id);
}
