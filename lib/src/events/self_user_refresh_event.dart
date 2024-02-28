
import '../../restrr.dart';

class SelfUserRefreshEvent extends RestrrEvent {
  final User selfUser;

  const SelfUserRefreshEvent({required super.api, required this.selfUser});
}
