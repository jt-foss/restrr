
import '../../../restrr.dart';
import '../cache/batch_cache_view.dart';
import '../cache/cache_view.dart';
import '../requests/responses/rest_response.dart';

class RequestUtils {
  const RequestUtils._();

  static Future<T> getOrRetrieveSingle<T extends RestrrEntity>(
      {required Id key,
      required RestrrEntityCacheView<T> cacheView,
      required CompiledRoute compiledRoute,
      required T Function(dynamic) mapper,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && cacheView.contains(key)) {
      return cacheView.get(key)!;
    }
    final RestResponse<T> response = await RequestHandler.request(
        route: compiledRoute,
        routeOptions: cacheView.api.routeOptions,
        bearerToken: noAuth ? null : cacheView.api.session.token,
        mapper: mapper);
    if (response.hasError) {
      throw response.error!;
    }
    return response.data!;
  }

  static Future<List<T>> getOrRetrieveMulti<T extends RestrrEntity>(
      {required RestrrEntityBatchCacheView<T> batchCache,
      required CompiledRoute compiledRoute,
      required T Function(dynamic) mapper,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && batchCache.hasSnapshot) {
      return batchCache.get()!;
    }
    final RestResponse<List<T>> response = await RequestHandler.multiRequest(
        route: compiledRoute,
        routeOptions: batchCache.api.routeOptions,
        bearerToken: noAuth ? null : batchCache.api.session.token,
        mapper: mapper);
    if (response.hasError) {
      throw response.error!;
    }
    final List<T> remote = response.data!;
    batchCache.update(remote);
    return remote;
  }
}
