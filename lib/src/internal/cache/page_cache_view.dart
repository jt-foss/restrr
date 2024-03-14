import 'package:restrr/src/internal/restrr_impl.dart';

import '../../../restrr.dart';

class PageCacheView<T extends RestrrEntity> {
  final RestrrImpl api;

  PageCacheView(this.api);

  final Map<(int, int), Page<T>> _pageCache = {};

  Page<T>? get(int page, int limit) => _pageCache[(page, limit)];

  void cache(Page<T> value) => _pageCache[(value.pageNumber, value.limit)] = value;

  void clear() => _pageCache.clear();

  bool contains(int page, int limit) => _pageCache.containsKey((page, limit));
}
