import '../../restrr.dart';
import '../internal/requests/responses/rest_response.dart';
import '../internal/restrr_impl.dart';
import '../internal/utils/request_utils.dart';

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

  Future<Restrr> login({required String username, required String password, String? sessionName}) async {
    return _handleAuthProcess(authFunction: (apiImpl) {
      return apiImpl.requestHandler.apiRequest(
          route: SessionRoutes.create.compile(),
          body: {
            'username': username,
            'password': password,
            'session_name': sessionName,
          },
          noAuth: true,
          mapper: (json) => apiImpl.entityBuilder.buildPartialSession(json));
    });
  }

  Future<Restrr> refresh({required String sessionToken}) async {
    return _handleAuthProcess(authFunction: (apiImpl) {
      return apiImpl.requestHandler.apiRequest(
          route: SessionRoutes.refresh.compile(),
          bearerTokenOverride: sessionToken,
          mapper: (json) => apiImpl.entityBuilder.buildPartialSession(json));
    });
  }

  Future<Restrr> _handleAuthProcess(
      {required Future<RestResponse<PartialSession>> Function(RestrrImpl) authFunction}) async {
    // check if the URI is valid and the API is healthy
    final ServerInfo statusResponse = await Restrr.checkUri(uri, isWeb: options.isWeb);
    Restrr.log.config('Host: $uri, API v${statusResponse.apiVersion}');
    // build api instance
    final RestrrImpl apiImpl = RestrrImpl(
        options: options,
        routeOptions: RouteOptions(hostUri: uri, apiVersion: statusResponse.apiVersion),
        eventMap: _eventMap);
    // call auth function
    final RestResponse<PartialSession> response = await authFunction(apiImpl);
    if (response.hasError) {
      throw response.error!;
    }
    if (response.data is! Session) {
      throw ArgumentError('The response data is not a session');
    }
    apiImpl.session = response.data! as Session;

    // Retrieve all accounts & currencies to make them available in the cache
    try {
      final List<Account> accounts =
      await RequestUtils.fetchAllPaginated<Account, AccountId>(apiImpl, await apiImpl.retrieveAllAccounts(limit: 50));
      Restrr.log.info('Cached ${accounts.length} account(s)');
    } catch (e) {
      Restrr.log.warning('Failed to cache accounts: $e');
    }

    try {
      final List<Currency> currencies = await RequestUtils.fetchAllPaginated<Currency, CurrencyId>(
          apiImpl, await apiImpl.retrieveAllCurrencies(limit: 50));
      Restrr.log.info('Cached ${currencies.length} currencies');
    } catch (e) {
      Restrr.log.warning('Failed to cache currencies: $e');
    }

    apiImpl.eventHandler.fire(ReadyEvent(api: apiImpl));
    return apiImpl;
  }
}
