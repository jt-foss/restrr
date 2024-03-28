import 'package:restrr/src/internal/restrr_impl.dart';

import '../../../restrr.dart';

class BatchCacheView<E extends Id<T>, T extends RestrrEntity<T, E>> {
  final RestrrImpl api;

  BatchCacheView(this.api);

  List<T>? _lastSnapshot;

  List<T>? get() => _lastSnapshot;

  void update(List<T> value) => _lastSnapshot = value;

  void clear() => _lastSnapshot = null;

  bool get hasSnapshot => _lastSnapshot != null;
}
