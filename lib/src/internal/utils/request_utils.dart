import 'package:restrr/src/internal/cache/cache_view.dart';
import 'package:restrr/src/internal/requests/responses/paginated_response.dart';

import '../../../restrr.dart';
import '../cache/batch_cache_view.dart';
import '../requests/responses/rest_response.dart';

class RequestUtils {
  const RequestUtils._();

  static Future<List<E>> fetchAllPaginated<E extends RestrrEntity<E, ID>, ID extends EntityId<E>>(
      Restrr api, Paginated<E> firstBatch,
      {Duration? delay}) async {
    final List<E> all = [...firstBatch.items];
    Paginated<E> current = firstBatch;
    while (current.hasNext) {
      if (delay != null) {
        await Future.delayed(delay);
      }
      final Paginated<E> next = await current.nextPage!.call(api);
      current = next;
      all.addAll(next.items);
    }
    return all;
  }

  static Future<bool> deleteSingle<E extends RestrrEntity<E, ID>, ID extends EntityId<E>>(
      {required CompiledRoute compiledRoute,
      required Restrr api,
      required EntityId key,
      required EntityCacheView<E, ID> cacheView,
      bool noAuth = false}) async {
    final RestResponse<bool> response = await RequestHandler.noResponseRequest(
        route: compiledRoute, routeOptions: api.routeOptions, bearerToken: noAuth ? null : api.session.token);
    if (response.hasData && response.data!) {
      cacheView.remove(key.value);
      return true;
    }
    return false;
  }

  static Future<E> getOrRetrieveSingle<E extends RestrrEntity<E, ID>, ID extends EntityId<E>>(
      {required EntityId key,
      required EntityCacheView<E, ID> cacheView,
      required CompiledRoute compiledRoute,
      required E Function(dynamic) mapper,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && cacheView.contains(key.value)) {
      return cacheView.get(key.value)!;
    }
    final RestResponse<E> response = await RequestHandler.request(
        route: compiledRoute,
        routeOptions: cacheView.api.routeOptions,
        bearerToken: noAuth ? null : cacheView.api.session.token,
        mapper: mapper);
    if (response.hasError) {
      throw response.error!;
    }
    return response.data!;
  }

  static Future<List<E>> getOrRetrieveMulti<E extends RestrrEntity<E, ID>, ID extends EntityId<E>>(
      {required BatchCacheView<E, ID> batchCache,
      required CompiledRoute compiledRoute,
      required E Function(dynamic) mapper,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && batchCache.hasSnapshot) {
      return batchCache.get()!;
    }
    final RestResponse<List<E>> response = await RequestHandler.multiRequest(
        route: compiledRoute,
        routeOptions: batchCache.api.routeOptions,
        bearerToken: noAuth ? null : batchCache.api.session.token,
        mapper: mapper);
    if (response.hasError) {
      throw response.error!;
    }
    final List<E> remote = response.data!;
    batchCache.update(remote);
    return remote;
  }

  static Future<Paginated<E>> getOrRetrievePage<E extends RestrrEntity<E, ID>, ID extends EntityId<E>>(
      {required PageCacheView<E, ID> pageCache,
      required CompiledRoute compiledRoute,
      required E Function(dynamic) mapper,
      required int page,
      required int limit,
      bool forceRetrieve = false,
      bool noAuth = false}) async {
    if (!forceRetrieve && pageCache.contains((page, limit))) {
      return pageCache.get((page, limit))!;
    }
    final RestResponse<List<E>> response = await RequestHandler.paginatedRequest(
        route: compiledRoute,
        routeOptions: pageCache.api.routeOptions,
        page: page,
        limit: limit,
        bearerToken: noAuth ? null : pageCache.api.session.token,
        mapper: mapper);
    if (response.hasError) {
      throw response.error!;
    }
    final Paginated<E> remote = (response as PaginatedResponse<E>).toPage();
    pageCache.cache(remote);
    return remote;
  }
}
