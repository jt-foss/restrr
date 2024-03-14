import 'package:restrr/src/internal/cache/page_cache_view.dart';
import 'package:restrr/src/internal/requests/responses/rest_response.dart';
import 'package:restrr/src/internal/utils/request_utils.dart';

import '../../restrr.dart';
import '../api/events/event_handler.dart';
import 'cache/cache_view.dart';
import 'entity_builder.dart';

class RestrrImpl implements Restrr {
  @override
  final RestrrOptions options;
  @override
  final RouteOptions routeOptions;

  late final RestrrEventHandler eventHandler;
  late final RequestHandler requestHandler = RequestHandler(this);
  late final EntityBuilder entityBuilder = EntityBuilder(api: this);

  /* Caches */

  late final IdCacheView<Currency> currencyCache = IdCacheView(this);
  late final IdCacheView<Session> sessionCache = IdCacheView(this);
  late final IdCacheView<User> userCache = IdCacheView(this);

  late final PageCacheView<Currency> currencyPageCache = PageCacheView(this);
  late final PageCacheView<Session> sessionPageCache = PageCacheView(this);

  RestrrImpl({required this.routeOptions, required Map<Type, Function> eventMap, this.options = const RestrrOptions()})
      : eventHandler = RestrrEventHandler(eventMap);

  @override
  late final Session session;

  @override
  User get selfUser => session.user;

  @override
  void on<T extends RestrrEvent>(Type type, void Function(T) func) => eventHandler.on(type, func);

  /* Users */

  @override
  Future<User> retrieveSelf({bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveSingle(
        key: selfUser.id,
        cacheView: userCache,
        compiledRoute: UserRoutes.getSelf.compile(),
        mapper: (json) => entityBuilder.buildUser(json),
        forceRetrieve: forceRetrieve);
  }

  /* Sessions */

  @override
  Future<Session> retrieveCurrentSession({bool forceRetrieve = false}) {
    return RequestUtils.getOrRetrieveSingle(
        key: session.id,
        cacheView: sessionCache,
        compiledRoute: SessionRoutes.getCurrent.compile(),
        mapper: (json) => entityBuilder.buildSession(json),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<Session> retrieveSessionById(Id id, {bool forceRetrieve = false}) {
    return RequestUtils.getOrRetrieveSingle(
        key: id,
        cacheView: sessionCache,
        compiledRoute: SessionRoutes.getById.compile(params: [id]),
        mapper: (json) => entityBuilder.buildSession(json),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<Page<Session>> retrieveAllSessions({int page = 1, int limit = 25, bool forceRetrieve = false}) {
    return RequestUtils.getOrRetrievePage(
        pageCache: sessionPageCache,
        compiledRoute: SessionRoutes.getAll.compile(),
        page: page,
        limit: limit,
        mapper: (json) => entityBuilder.buildSession(json),
        forceRetrieve: forceRetrieve
    );
  }

  @override
  Future<bool> deleteCurrentSession() async {
    final RestResponse<bool> response =
    await requestHandler.noResponseApiRequest(route: SessionRoutes.deleteCurrent.compile());
    if (response.hasData && response.data!) {
      eventHandler.fire(SessionDeleteEvent(api: this));
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteAllSessions() async {
    final RestResponse<bool> response =
        await requestHandler.noResponseApiRequest(route: SessionRoutes.deleteAll.compile());
    return response.hasData && response.data!;
  }

  /* Currencies */

  @override
  Future<Currency> createCurrency(
      {required String name, required String symbol, required String isoCode, required int decimalPlaces}) async {
    final RestResponse<Currency> response = await requestHandler
        .apiRequest(route: CurrencyRoutes.create.compile(), mapper: (json) => entityBuilder.buildCurrency(json), body: {
      'name': name,
      'symbol': symbol,
      'iso_code': isoCode,
      'decimal_places': decimalPlaces,
    });
    if (response.hasError) {
      throw response.error!;
    }
    return response.data!;
  }

  @override
  Future<Currency> retrieveCurrencyById(Id id, {bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrieveSingle(
        key: id,
        cacheView: currencyCache,
        compiledRoute: CurrencyRoutes.getById.compile(params: [id]),
        mapper: (json) => entityBuilder.buildCurrency(json),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<Page<Currency>> retrieveAllCurrencies({int page = 1, int limit = 25, bool forceRetrieve = false}) async {
    return RequestUtils.getOrRetrievePage(
        pageCache: currencyPageCache,
        compiledRoute: CurrencyRoutes.getAll.compile(),
        page: page,
        limit: limit,
        mapper: (json) => entityBuilder.buildCurrency(json),
        forceRetrieve: forceRetrieve
    );
  }
}
