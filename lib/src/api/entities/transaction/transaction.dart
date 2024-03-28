import 'package:restrr/restrr.dart';

abstract class TransactionId extends Id<Transaction> {}

abstract class Transaction extends RestrrEntity<Transaction, TransactionId> {
  @override
  TransactionId get id;

  AccountId? get sourceId;
  AccountId? get destinationId;
  int get amount;
  CurrencyId get currencyId;
  String? get description;
  Id? get budgetId;
  DateTime get createdAt;
  DateTime get executedAt;

  TransactionType get type;

  Future<bool> delete();

  Future<Transaction> update({
    AccountId? sourceId,
    AccountId? destinationId,
    int? amount,
    CurrencyId? currencyId,
    String? description,
    Id? budgetId,
    DateTime? executedAt,
  });
}
