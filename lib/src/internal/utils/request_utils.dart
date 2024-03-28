import 'package:restrr/src/internal/cache/cache_view.dart';
import 'package:restrr/src/internal/requests/responses/paginated_response.dart';

import '../../../restrr.dart';
import '../cache/batch_cache_view.dart';
import '../requests/responses/rest_response.dart';

class RequestUtils {
  const RequestUtils._();

  static Future<List<T>> fetchAllPaginated<E extends Id<T>, T extends RestrrEntity<T, E>>(Restrr api, Paginated<T> firstBatch,
      {Duration? delay}) async {
    final List<T> all = [...firstBatch.items];
    Paginated<T> current = firstBatch;
    while (current.hasNext) {
      if (delay != null) {
        await Future.delayed(delay);
      }
      final Paginated<T> next = await current.nextPage!.call(api);
      current = next;
      all.addAll(next.items);
    }
    return all;
  }

  static Future<T> getOrRetrieveSingle<E extends Id<T>, T extends RestrrEntity<T, E>>(
      {required Id key,
      required EntityCacheView<E, T> cacheView,
      required CompiledRoute compiledRoute,
      required T Function(dynamic) mapper,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && cacheView.contains(key.id)) {
      return cacheView.get(key.id)!;
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

  static Future<List<T>> getOrRetrieveMulti<E extends Id<T>, T extends RestrrEntity<T, E>>(
      {required BatchCacheView<E, T> batchCache,
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

  static Future<Paginated<T>> getOrRetrievePage<E extends Id<T>, T extends RestrrEntity<T, E>>(
      {required PageCacheView<E, T> pageCache,
      required CompiledRoute compiledRoute,
      required T Function(dynamic) mapper,
      required int page,
      required int limit,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && pageCache.contains((page, limit))) {
      return pageCache.get((page, limit))!;
    }
    final RestResponse<List<T>> response = await RequestHandler.paginatedRequest(
        route: compiledRoute,
        routeOptions: pageCache.api.routeOptions,
        page: page,
        limit: limit,
        bearerToken: noAuth ? null : pageCache.api.session.token,
        mapper: mapper);
    if (response.hasError) {
      throw response.error!;
    }
    final Paginated<T> remote = (response as PaginatedResponse<T>).toPage();
    pageCache.cache(remote);
    return remote;
  }
}
