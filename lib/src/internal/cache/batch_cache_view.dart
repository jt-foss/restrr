import 'package:restrr/src/internal/restrr_impl.dart';

import '../../../restrr.dart';

class BatchCacheView<T extends RestrrEntity> {
  final RestrrImpl api;

  BatchCacheView(this.api);

  List<T>? _lastSnapshot;

  List<T>? get() => _lastSnapshot;

  void update(List<T> value) => _lastSnapshot = value;

  void clear() => _lastSnapshot = null;

  bool get hasSnapshot => _lastSnapshot != null;
}
