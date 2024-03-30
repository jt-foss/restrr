import 'package:restrr/restrr.dart';
import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../utils/request_utils.dart';

class CurrencyIdImpl extends IdImpl<Currency> implements CurrencyId {
  const CurrencyIdImpl({required super.api, required super.value});

  @override
  Currency? get() => api.currencyCache.get(value);

  @override
  Future<Currency> retrieve({forceRetrieve = false}) => RequestUtils.getOrRetrieveSingle(
        key: this,
        cacheView: api.currencyCache,
        compiledRoute: CurrencyRoutes.getById.compile(params: [value]),
        mapper: (json) => api.entityBuilder.buildCurrency(json),
        forceRetrieve: forceRetrieve);
}

class CurrencyImpl extends RestrrEntityImpl<Currency, CurrencyId> implements Currency {
  @override
  final String name;
  @override
  final String symbol;
  @override
  final int decimalPlaces;
  @override
  final String? isoCode;

  const CurrencyImpl({
    required super.api,
    required super.id,
    required this.name,
    required this.symbol,
    required this.decimalPlaces,
    required this.isoCode,
  });
}
