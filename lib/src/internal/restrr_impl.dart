import 'package:restrr/src/internal/requests/responses/rest_response.dart';
import 'package:restrr/src/internal/utils/request_utils.dart';

import '../../restrr.dart';
import '../api/events/event_handler.dart';
import 'cache/batch_cache_view.dart';
import 'cache/cache_view.dart';
import 'entity_builder.dart';

class RestrrImpl implements Restrr {
  @override
  final RestrrOptions options;
  @override
  final RouteOptions routeOptions;

  late final RestrrEventHandler eventHandler;

  /* Caches */

  late final RestrrEntityCacheView<Currency> currencyCache = RestrrEntityCacheView(this);
  late final RestrrEntityCacheView<Session> sessionCache = RestrrEntityCacheView(this);
  late final RestrrEntityCacheView<User> userCache = RestrrEntityCacheView(this);

  late final RestrrEntityBatchCacheView<Currency> currencyBatchCache = RestrrEntityBatchCacheView(this);

  RestrrImpl({required this.routeOptions, required Map<Type, Function> eventMap, this.options = const RestrrOptions()})
      : eventHandler = RestrrEventHandler(eventMap);

  late final EntityBuilder entityBuilder = EntityBuilder(api: this);

  @override
  late final Session session;

  @override
  User get selfUser => session.user;

  @override
  void on<T extends RestrrEvent>(Type type, void Function(T) func) => eventHandler.on(type, func);

  @override
  Future<User?> retrieveSelf({bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveSingle(
        key: selfUser.id,
        cacheView: userCache,
        compiledRoute: UserRoutes.getSelf.compile(),
        mapper: (json) => entityBuilder.buildUser(json),
        forceRetrieve: forceRetrieve
    );
  }

  @override
  Future<bool> logout() async {
    final RestResponse<bool> response = await _sessionService.deleteCurrent();
    return response.hasData && response.data!;
  }

  /* Sessions */

  @override
  Future<Session?> retrieveCurrent({bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveSingle(
        key: session.id,
        cacheView: sessionCache,
        compiledRoute: SessionRoutes.getCurrent.compile(),
        mapper: (json) => entityBuilder.buildSession(json),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<Session?> retrieveById(Id id, {bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveSingle(
        key: id,
        cacheView: sessionCache,
        compiledRoute: SessionRoutes.getById.compile(params: [id]),
        mapper: (json) => entityBuilder.buildSession(json),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<bool> deleteById(Id id) async {
    final RestResponse<bool> response = await _sessionService.deleteById(id);
    return response.hasData && response.data!;
  }

  @override
  Future<bool> deleteAll() async {
    final RestResponse<bool> response = await _sessionService.deleteAll();
    return response.hasData && response.data!;
  }

  /* Currencies */

  @override
  Future<List<Currency>?> retrieveAllCurrencies({bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveMulti(
      batchCache: currencyBatchCache,
      compiledRoute: CurrencyRoutes.getAll.compile(),
      mapper: (json) => entityBuilder.buildCurrency(json),
      forceRetrieve: forceRetrieve
    );
  }

  @override
  Future<Currency?> createCurrency(
      {required String name, required String symbol, required String isoCode, required int decimalPlaces}) async {
    final RestResponse<Currency> response = await _currencyService.createCurrency(
        name: name, symbol: symbol, isoCode: isoCode, decimalPlaces: decimalPlaces);
    return response.data;
  }

  @override
  Future<Currency?> retrieveCurrencyById(Id id, {bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveSingle(
        key: id,
        cacheView: currencyCache,
        compiledRoute: CurrencyRoutes.getById.compile(params: [id]),
        mapper: (json) => entityBuilder.buildCurrency(json),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<bool> deleteCurrencyById(Id id) async {
    final RestResponse<bool> response = await _currencyService.deleteCurrencyById(id);
    return response.hasData && response.data!;
  }

  @override
  Future<Currency?> updateCurrencyById(Id id,
      {String? name, String? symbol, String? isoCode, int? decimalPlaces}) async {
    final RestResponse<Currency> response = await _currencyService.updateCurrencyById(id,
        name: name, symbol: symbol, isoCode: isoCode, decimalPlaces: decimalPlaces);
    return response.data;
  }
}
