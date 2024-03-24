import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../../restrr.dart';
import '../requests/responses/rest_response.dart';

class TransactionImpl extends RestrrEntityImpl implements Transaction {
  @override
  final int? source;
  @override
  final int? destination;
  @override
  final int amount;
  @override
  final Id currency;
  @override
  final String? description;
  @override
  final Id? budget;
  @override
  final DateTime createdAt;
  @override
  final DateTime executedAt;

  const TransactionImpl({
    required super.api,
    required super.id,
    required this.source,
    required this.destination,
    required this.amount,
    required this.currency,
    required this.description,
    required this.budget,
    required this.createdAt,
    required this.executedAt,
  }) : assert(source != null || destination != null);

  @override
  TransactionType get type {
    if (source != null && destination != null) {
      return TransactionType.transfer;
    }
    if (source != null) {
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
      {int? source,
      int? destination,
      int? amount,
      int? currency,
      String? description,
      Id? budget,
      DateTime? executedAt}) async {
    if (source == null &&
        destination == null &&
        amount == null &&
        currency == null &&
        description == null &&
        budget == null &&
        executedAt == null) {
      throw ArgumentError('At least one field must be set');
    }
    final RestResponse<Transaction> response = await api.requestHandler.apiRequest(
        route: TransactionRoutes.patchById.compile(params: [id]),
        mapper: (json) => api.entityBuilder.buildTransaction(json),
        body: {
          if (source != null) 'source': source,
          if (destination != null) 'destination': destination,
          if (amount != null) 'amount': amount,
          if (currency != null) 'currency': currency,
          if (description != null) 'description': description,
          if (budget != null) 'budget': budget,
          if (executedAt != null) 'executed_at': executedAt.toUtc().toIso8601String(),
        });
    return response.data!;
  }

  @override
  Account? getSourceAccount() => source == null ? null : api.accountCache.get(source!);

  @override
  Future<Account>? retrieveSourceAccount({bool forceRetrieve = false}) {
    if (source == null) {
      return null;
    }
    return api.retrieveAccountById(source!, forceRetrieve: forceRetrieve);
  }

  @override
  Account? getDestinationAccount() => destination == null ? null : api.accountCache.get(destination!);

  @override
  Future<Account>? retrieveDestinationAccount({bool forceRetrieve = false}) {
    if (destination == null) {
      return null;
    }
    return api.retrieveAccountById(destination!, forceRetrieve: forceRetrieve);
  }
}
