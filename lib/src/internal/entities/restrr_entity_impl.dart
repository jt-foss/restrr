import '../../../restrr.dart';
import '../restrr_impl.dart';

class RestrrEntityImpl implements RestrrEntity {
  @override
  final RestrrImpl api;
  @override
  final Id id;

  const RestrrEntityImpl({
    required this.api,
    required this.id,
  });
}