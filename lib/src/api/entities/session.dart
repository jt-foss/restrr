import '../../../restrr.dart';

abstract class Session extends RestrrEntity {
  String get token;
  String? get name;
  DateTime get expiredAt;
  User get user;

  Future<bool> delete();
}
