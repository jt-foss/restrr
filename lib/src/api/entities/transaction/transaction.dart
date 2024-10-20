import 'package:restrr/restrr.dart';

abstract class TransactionId extends EntityId<Transaction> {}

abstract class Transaction extends RestrrEntity<Transaction, TransactionId> {
  @override
  TransactionId get id;

  AccountId? get sourceId;
  AccountId? get destinationId;
  int get amount;
  CurrencyId get currencyId;
  String get name;
  String? get description;
  EntityId? get budgetId;
  DateTime get createdAt;
  DateTime get executedAt;

  TransactionType getType(Account current);

  Future<bool> delete();

  Future<Transaction> update({
    Id? sourceId,
    Id? destinationId,
    int? amount,
    Id? currencyId,
    String? name,
    String? description,
    Id? budgetId,
    DateTime? executedAt,
  });
}
