import '../../../../restrr.dart';

abstract class PartialSession extends RestrrEntity {
  String? get name;
  DateTime get createdAt;
  DateTime get expiresAt;
  User get user;

  Future<bool> delete();
}
