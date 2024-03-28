import '../../../../restrr.dart';

abstract class PartialSessionId extends Id<PartialSession> {}

abstract class PartialSession extends RestrrEntity<PartialSession, PartialSessionId> {
  @override
  PartialSessionId get id;

  String? get name;
  DateTime get createdAt;
  DateTime get expiresAt;
  User get user;

  Future<bool> delete();
}
