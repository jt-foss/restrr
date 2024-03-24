import 'package:restrr/restrr.dart';

abstract class Transaction extends RestrrEntity {
  int? get source;
  int? get destination;
  int get amount;
  Id get currency;
  String? get description;
  Id? get budget;
  DateTime get createdAt;
  DateTime get executedAt;

  TransactionType get type;

  Future<bool> delete();

  Future<Transaction> update({
    int? source,
    int? destination,
    int? amount,
    Id? currency,
    String? description,
    Id? budget,
    DateTime? executedAt,
  });
}
