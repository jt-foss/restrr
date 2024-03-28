import '../../../restrr.dart';

abstract class AccountId extends Id<Account> {}

abstract class Account extends RestrrEntity<Account, AccountId> {
  @override
  AccountId get id;

  String get name;
  String? get description;
  String? get iban;
  int get balance;
  int get originalBalance;
  CurrencyId get currencyId;
  DateTime get createdAt;

  Future<bool> delete();

  Future<Account> update({String? name, String? description, String? iban, int? originalBalance, Id? currencyId});

  Future<Paginated<Transaction>> retrieveAllTransactions({int page = 1, int limit = 25, bool forceRetrieve = false});
}
