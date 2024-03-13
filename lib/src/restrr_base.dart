import 'package:logging/logging.dart';
import 'package:restrr/src/cache/batch_cache_view.dart';
import 'package:restrr/src/events/event_handler.dart';
import 'package:restrr/src/requests/route.dart';
import 'package:restrr/src/service/api_service.dart';
import 'package:restrr/src/service/currency_service.dart';
import 'package:restrr/src/service/session_service.dart';
import 'package:restrr/src/service/user_service.dart';

import '../restrr.dart';
import 'cache/cache_view.dart';

class RestrrOptions {
  final bool isWeb;
  final bool disableLogging;
  const RestrrOptions({this.isWeb = false, this.disableLogging = false});
}

/// A builder for creating a new [Restrr] instance.
/// The [Restrr] instance is created by calling [create].
class RestrrBuilder {
  final Map<Type, Function> _eventMap = {};

  final Uri uri;

  final RestrrOptions options;

  RestrrBuilder({required this.uri, this.options = const RestrrOptions()});

  RestrrBuilder on<T extends RestrrEvent>(Type type, void Function(T) func) {
    _eventMap[type] = func;
    return this;
  }

  Future<RestResponse<Restrr>> login({required String username, required String password}) async {
    return _handleAuthProcess(authFunction: (apiImpl) => apiImpl._sessionService.create(username, password));
  }

  Future<RestResponse<Restrr>> refresh() async {
    return _handleAuthProcess(authFunction: (apiImpl) => apiImpl._sessionService.refresh());
  }

  Future<RestResponse<RestrrImpl>> _handleAuthProcess(
      {required Future<RestResponse<Session>> Function(RestrrImpl) authFunction}) async {
    // check if the URI is valid and the API is healthy
    final RestResponse<HealthResponse> statusResponse = await Restrr.checkUri(uri, isWeb: options.isWeb);
    if (statusResponse.hasError) {
      Restrr.log.warning('Invalid financrr URI: $uri');
      return (statusResponse.error == RestrrError.unknown
              ? RestrrError.invalidUri
              : statusResponse.error ?? RestrrError.invalidUri)
          .toRestResponse(statusCode: statusResponse.statusCode);
    }
    Restrr.log.config('Host: $uri, API v${statusResponse.data!.apiVersion}');
    // build api instance
    final RestrrImpl apiImpl = RestrrImpl._(
        options: options,
        routeOptions: RouteOptions(hostUri: uri, apiVersion: statusResponse.data!.apiVersion),
        eventMap: _eventMap);
    // call auth function
    final RestResponse<Session> response = await authFunction(apiImpl);
    if (response.hasError) {
      return response.error?.toRestResponse(statusCode: response.statusCode) ?? RestrrError.unknown.toRestResponse();
    }
    apiImpl.session = response.data!;
    apiImpl.eventHandler.fire(ReadyEvent(api: apiImpl));
    return RestResponse(data: apiImpl, statusCode: response.statusCode);
  }
}

abstract class Restrr {
  static final Logger log = Logger('Restrr');

  /// Getter for the [EntityBuilder] of this [Restrr] instance.
  EntityBuilder get entityBuilder;

  RestrrEventHandler get eventHandler;

  RestrrOptions get options;
  RouteOptions get routeOptions;

  Session get session;

  /// The currently authenticated user.
  User get selfUser => session.user;

  /// Checks whether the given [uri] is valid and the API is healthy.
  static Future<RestResponse<HealthResponse>> checkUri(Uri uri, {bool isWeb = false}) async {
    return RequestHandler.request(
        route: StatusRoutes.health.compile(),
        mapper: (json) => EntityBuilder.buildHealthResponse(json),
        isWeb: isWeb,
        routeOptions: RouteOptions(hostUri: uri));
  }

  void on<T extends RestrrEvent>(Type type, void Function(T) func);

  /// Retrieves the currently authenticated user.
  Future<User?> retrieveSelf({bool forceRetrieve = false});

  /// Logs out the current user.
  Future<bool> logout();

  Future<List<Currency>?> retrieveAllCurrencies({bool forceRetrieve = false});

  Future<Currency?> createCurrency(
      {required String name, required String symbol, required String isoCode, required int decimalPlaces});

  Future<Currency?> retrieveCurrencyById(Id id, {bool forceRetrieve = false});

  Future<bool> deleteCurrencyById(Id id);

  Future<Currency?> updateCurrencyById(Id id, {String? name, String? symbol, String? isoCode, int? decimalPlaces});
}

class RestrrImpl implements Restrr {
  @override
  final RestrrOptions options;
  @override
  final RouteOptions routeOptions;

  @override
  late final RestrrEventHandler eventHandler;

  /* Services */

  late final SessionService _sessionService = SessionService(api: this);
  late final UserService _userService = UserService(api: this);
  late final CurrencyService _currencyService = CurrencyService(api: this);

  /* Caches */

  late final RestrrEntityCacheView<User> userCache = RestrrEntityCacheView();
  late final RestrrEntityCacheView<Currency> currencyCache = RestrrEntityCacheView();

  late final RestrrEntityBatchCacheView<Currency> _currencyBatchCache = RestrrEntityBatchCacheView();

  RestrrImpl._(
      {required this.routeOptions, required Map<Type, Function> eventMap, this.options = const RestrrOptions()})
      : eventHandler = RestrrEventHandler(eventMap);

  @override
  late final EntityBuilder entityBuilder = EntityBuilder(api: this);

  @override
  late final Session session;

  @override
  User get selfUser => session.user;

  @override
  void on<T extends RestrrEvent>(Type type, void Function(T) func) => eventHandler.on(type, func);

  @override
  Future<User?> retrieveSelf({bool forceRetrieve = false}) async {
    return _getOrRetrieveSingle(
        key: selfUser.id,
        cacheView: userCache,
        retrieveFunction: (api) => api._userService.getSelf(),
        forceRetrieve: forceRetrieve);
  }

  @override
  Future<bool> logout() async {
    final RestResponse<bool> response = await _sessionService.delete();
    return response.hasData && response.data!;
  }

  @override
  Future<List<Currency>?> retrieveAllCurrencies({bool forceRetrieve = false}) async {
    return _getOrRetrieveMulti(
      batchCache: _currencyBatchCache,
      retrieveFunction: (api) => api._currencyService.retrieveAllCurrencies(),
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
    return _getOrRetrieveSingle(
        key: id,
        cacheView: currencyCache,
        retrieveFunction: (api) => api._currencyService.retrieveCurrencyById(id),
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

  Future<T?> _getOrRetrieveSingle<T extends RestrrEntity>(
      {required Id key,
      required RestrrEntityCacheView<T> cacheView,
      required Future<RestResponse<T>> Function(RestrrImpl) retrieveFunction,
      bool forceRetrieve = false}) async {
    if (!forceRetrieve && cacheView.contains(key)) {
      return cacheView.get(key)!;
    }
    final RestResponse<T> response = await retrieveFunction.call(this);
    return response.hasData ? response.data : null;
  }

  Future<List<T>?> _getOrRetrieveMulti<T extends RestrrEntity>(
      {required RestrrEntityBatchCacheView<T> batchCache,
      required Future<RestResponse<List<T>>> Function(RestrrImpl) retrieveFunction,
      bool forceRetrieve = false}) async {
    if (!forceRetrieve && batchCache.hasSnapshot) {
      return batchCache.get()!;
    }
    final RestResponse<List<T>> response = await retrieveFunction.call(this);
    if (response.hasData) {
      final List<T> remote = response.data!;
      batchCache.update(remote);
      return remote;
    }
    return null;
  }
}
