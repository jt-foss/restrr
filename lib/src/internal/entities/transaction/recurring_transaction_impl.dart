import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';
import 'package:restrr/src/internal/requests/responses/rest_response.dart';

import '../../../../restrr.dart';
import '../../utils/request_utils.dart';

class RecurringTransactionIdImpl extends IdImpl<RecurringTransaction> implements RecurringTransactionId {
  const RecurringTransactionIdImpl({required super.api, required super.value});

  @override
  RecurringTransaction? get() => api.recurringTransactionCache.get(this);

  @override
  Future<RecurringTransaction> retrieve({forceRetrieve = false}) => RequestUtils.getOrRetrieveSingle(
      api: api,
      key: this,
      cacheView: api.recurringTransactionCache,
      compiledRoute: RecurringTransactionRoutes.getById.compile(params: [value]),
      mapper: (json) => api.entityBuilder.buildRecurringTransaction(json),
      forceRetrieve: forceRetrieve);
}

class RecurringTransactionImpl extends RestrrEntityImpl<RecurringTransaction, RecurringTransactionId>
    implements RecurringTransaction {
  @override
  final TransactionTemplateId templateId;
  @override
  final DateTime? lastExecutedAt;
  @override
  final RecurringRule recurringRule;
  @override
  final DateTime createdAt;

  const RecurringTransactionImpl({
    required super.api,
    required super.id,
    required this.templateId,
    required this.lastExecutedAt,
    required this.recurringRule,
    required this.createdAt,
  });

  @override
  Future<bool> delete() => RequestUtils.deleteSingle(
      compiledRoute: RecurringTransactionRoutes.deleteById.compile(params: [id.value]),
      api: api,
      key: id,
      cacheView: api.recurringTransactionCache);

  @override
  Future<RecurringTransaction> update({
    Id? templateId,
    DateTime? lastExecutedAt,
    RecurringRule? recurringRule,
  }) async {
    if (templateId == null && lastExecutedAt == null && recurringRule == null) {
      throw ArgumentError('At least one field must be set');
    }
    final RestResponse<RecurringTransaction> response = await api.requestHandler.apiRequest(
      route: RecurringTransactionRoutes.patchById.compile(params: [id.value]),
      mapper: (json) => api.entityBuilder.buildRecurringTransaction(json),
      body: {
        if (templateId != null) 'template_id': templateId,
        if (lastExecutedAt != null) 'last_executed_at': lastExecutedAt.toIso8601String(),
        if (recurringRule != null) 'recurring_rule': recurringRule.toJson(),
      },
    );
    return response.data!;
  }
}
