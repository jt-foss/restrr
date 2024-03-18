import '../../../restrr.dart';

abstract class Account extends RestrrEntity {
  String get name;
  String? get description;
  String? get iban;
  int get balance;
  int get originalBalance;
  Id get currency;
  DateTime get createdAt;

  Future<bool> delete();

  Future<Account> update({String? name, String? description, String? iban, int? originalBalance, Id? currency});
}
