import '../../../../restrr.dart';

abstract class TransactionTemplateId extends EntityId<TransactionTemplate> {}

abstract class TransactionTemplate extends RestrrEntity<TransactionTemplate, TransactionTemplateId> {
  @override
  TransactionTemplateId get id;

  AccountId? get sourceId;
  AccountId? get destinationId;
  int get amount;
  CurrencyId get currencyId;
  String get name;
  String? get description;
  EntityId? get budgetId;
  DateTime get createdAt;

  Future<bool> delete();

  Future<TransactionTemplate> update({
    Id? sourceId,
    Id? destinationId,
    int? amount,
    Id? currencyId,
    String? name,
    String? description,
    Id? budgetId,
  });

  Future<RecurringTransaction> createRecurringTransaction(RecurringRule rule);
}
