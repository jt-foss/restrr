import '../../../../../restrr.dart';

abstract class RecurringTransactionId extends EntityId<RecurringTransaction> {}

abstract class RecurringTransaction extends RestrrEntity<RecurringTransaction, RecurringTransactionId> {
  @override
  RecurringTransactionId get id;

  TransactionTemplateId get templateId;
  DateTime? get lastExecutedAt;
  DateTime? get nextExecutedAt;
  RecurringRule get recurringRule;
  DateTime get createdAt;

  Future<bool> delete();

  Future<RecurringTransaction> update({
    Id? templateId,
    DateTime? lastExecutedAt,
    RecurringRule? recurringRule,
  });
}
