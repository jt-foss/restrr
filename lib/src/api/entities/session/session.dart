import 'package:restrr/src/api/entities/session/partial_session.dart';

import '../../../../restrr.dart';

abstract class Session extends PartialSession {
  String get token;
}
