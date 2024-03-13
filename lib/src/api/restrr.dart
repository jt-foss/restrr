import 'package:logging/logging.dart';

import '../../restrr.dart';
import 'events/event_handler.dart';

class RestrrOptions {
  final bool isWeb;
  final bool disableLogging;
  const RestrrOptions({this.isWeb = false, this.disableLogging = false});
}

class RouteOptions {
  final Uri hostUri;
  final int apiVersion;
  const RouteOptions({required this.hostUri, this.apiVersion = -1});
}

abstract class Restrr {
  static final Logger log = Logger('Restrr');

  RestrrOptions get options;
  RouteOptions get routeOptions;

  Session get session;

  /// The currently authenticated user.
  User get selfUser => session.user;

  void on<T extends RestrrEvent>(Type type, void Function(T) func);

  /// Retrieves the currently authenticated user.
  Future<User?> retrieveSelf({bool forceRetrieve = false});

  /// Logs out the current user.
  Future<bool> logout();

  Future<List<Currency>?> retrieveAllCurrencies({bool forceRetrieve = false});

  /* Sessions */

  Future<Session?> retrieveCurrent({bool forceRetrieve = false});

  Future<Session?> retrieveById(Id id, {bool forceRetrieve = false});

  Future<bool> deleteById(Id id);

  Future<bool> deleteAll();

  /* Currencies */

  Future<Currency?> createCurrency(
      {required String name, required String symbol, required String isoCode, required int decimalPlaces});

  Future<Currency?> retrieveCurrencyById(Id id, {bool forceRetrieve = false});

  Future<bool> deleteCurrencyById(Id id);

  Future<Currency?> updateCurrencyById(Id id, {String? name, String? symbol, String? isoCode, int? decimalPlaces});
}