import '../../../../restrr.dart';

abstract class PartialSession extends RestrrEntity {
  String? get name;
  DateTime get expiredAt;
  User get user;

  Future<bool> delete();
}
