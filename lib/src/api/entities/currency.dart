import '../../../restrr.dart';

abstract class Currency extends RestrrEntity {
  String get name;
  String get symbol;
  String get isoCode;
  int get decimalPlaces;
  int? get user;

  bool get isCustom;

  bool isCreatedBy(User user);

  Future<bool> delete();

  Future<Currency?> update({String? name, String? symbol, String? isoCode, int? decimalPlaces});
}