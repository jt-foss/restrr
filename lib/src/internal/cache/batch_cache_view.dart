import 'package:restrr/src/internal/restrr_impl.dart';

import '../../../restrr.dart';

class BatchCacheView<E extends RestrrEntity<E, ID>, ID extends EntityId<E>> {
  final RestrrImpl api;

  BatchCacheView(this.api);

  List<E>? _lastSnapshot;

  List<E>? get() => _lastSnapshot;

  void update(List<E> value) => _lastSnapshot = value;

  void clear() => _lastSnapshot = null;

  bool get hasSnapshot => _lastSnapshot != null;
}
