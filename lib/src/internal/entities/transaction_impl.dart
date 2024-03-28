import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../../restrr.dart';
import '../requests/responses/rest_response.dart';
import '../utils/request_utils.dart';

class TransactionIdImpl extends IdImpl<Transaction> implements TransactionId {
  const TransactionIdImpl({required super.api, required super.id});

  @override
  Transaction? get() {
    return api.transactionCache.get(id);
  }

  @override
  Future<Transaction> retrieve({forceRetrieve = false}) {
    return RequestUtils.getOrRetrieveSingle(
        key: this,
        cacheView: api.transactionCache,
        compiledRoute: TransactionRoutes.getById.compile(params: [id]),
        mapper: (json) => api.entityBuilder.buildTransaction(json),
        forceRetrieve: forceRetrieve);
  }
}

class TransactionImpl extends RestrrEntityImpl<Transaction, TransactionId> implements Transaction {
  @override
  final AccountId? sourceId;
  @override
  final AccountId? destinationId;
  @override
  final int amount;
  @override
  final CurrencyId currencyId;
  @override
  final String? description;
  @override
  final Id? budgetId;
  @override
  final DateTime createdAt;
  @override
  final DateTime executedAt;

  const TransactionImpl({
    required super.api,
    required super.id,
    required this.sourceId,
    required this.destinationId,
    required this.amount,
    required this.currencyId,
    required this.description,
    required this.budgetId,
    required this.createdAt,
    required this.executedAt,
  }) : assert(sourceId != null || destinationId != null);

  @override
  TransactionType get type {
    if (sourceId != null && destinationId != null) {
      return TransactionType.transfer;
    }
    if (sourceId != null) {
      return TransactionType.withdrawal;
    }
    return TransactionType.deposit;
  }

  @override
  Future<bool> delete() async {
    final RestResponse<bool> response =
        await api.requestHandler.noResponseApiRequest(route: TransactionRoutes.deleteById.compile(params: [id]));
    return response.hasData && response.data!;
  }

  @override
  Future<Transaction> update(
      {AccountId? sourceId,
      AccountId? destinationId,
      int? amount,
      CurrencyId? currencyId,
      String? description,
      Id? budgetId,
      DateTime? executedAt}) async {
    if (sourceId == null &&
        destinationId == null &&
        amount == null &&
        currencyId == null &&
        description == null &&
        budgetId == null &&
        executedAt == null) {
      throw ArgumentError('At least one field must be set');
    }
    final RestResponse<Transaction> response = await api.requestHandler.apiRequest(
        route: TransactionRoutes.patchById.compile(params: [id]),
        mapper: (json) => api.entityBuilder.buildTransaction(json),
        body: {
          if (sourceId != null) 'source_id': sourceId.id,
          if (destinationId != null) 'destination_id': destinationId.id,
          if (amount != null) 'amount': amount,
          if (currencyId != null) 'currency': currencyId.id,
          if (description != null) 'description': description,
          if (budgetId != null) 'budget_id': budgetId.id,
          if (executedAt != null) 'executed_at': executedAt.toUtc().toIso8601String(),
        });
    return response.data!;
  }
}
