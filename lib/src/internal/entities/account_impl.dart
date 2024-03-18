import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../../restrr.dart';

class AccountImpl extends RestrrEntityImpl implements Account {
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? iban;
  @override
  final double balance;
  @override
  final double originalBalance;
  @override
  final Id currency;
  @override
  final DateTime createdAt;

  const AccountImpl({
    required super.api,
    required super.id,
    required this.name,
    required this.description,
    required this.iban,
    required this.balance,
    required this.originalBalance,
    required this.currency,
    required this.createdAt,
  });

  @override
  Future<bool> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Account> update({String? name, String? description, String? iban, double? balance, double? originalBalance, Id? currency}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}