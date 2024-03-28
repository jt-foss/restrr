import '../../../restrr.dart';
import '../restrr_impl.dart';

class EntityCacheView<E extends Id<T>, T extends RestrrEntity<T, E>> extends MapCacheView<int, T> {
  EntityCacheView(RestrrImpl api) : super(api, valueFunction: (entity) => entity.id.id);
}

class PageCacheView<E extends Id<T>, T extends RestrrEntity<T, E>> extends MapCacheView<(int, int), Paginated<T>> {
  PageCacheView(RestrrImpl api) : super(api, valueFunction: (page) => (page.pageNumber, page.limit));
}

abstract class MapCacheView<K, V> {
  final RestrrImpl api;
  final K Function(V) valueFunction;

  MapCacheView(this.api, {required this.valueFunction});

  final Map<K, V> _cache = {};

  V? get(K key) => _cache[key];

  List<V> getAll() => _cache.values.toList();

  V cache(V value) => _cache[valueFunction.call(value)] = value;

  void clear() => _cache.clear();

  bool contains(K key) => _cache.containsKey(key);
}
