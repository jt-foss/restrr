import 'package:restrr/restrr.dart';

import 'api_service.dart';

class CurrencyService extends ApiService {
  const CurrencyService({required super.api});

  Future<RestResponse<List<Currency>>> retrieveAllCurrencies() async {
    return multiRequest(
        route: CurrencyRoutes.getAll.compile(),
        mapper: (json) => api.entityBuilder.buildCurrency(json),
        errorMap: {
          401: RestrrError.notSignedIn,
        });
  }

  Future<RestResponse<Currency>> createCurrency(
      {required String name, required String symbol, required String isoCode, required int decimalPlaces}) async {
    return request(
        route: CurrencyRoutes.create.compile(),
        mapper: (json) => api.entityBuilder.buildCurrency(json),
        body: {
          'name': name,
          'symbol': symbol,
          'iso_code': isoCode,
          'decimal_places': decimalPlaces,
        },
        errorMap: {
          401: RestrrError.notSignedIn,
        });
  }

  Future<RestResponse<Currency>> retrieveCurrencyById(Id id) async {
    return request(
        route: CurrencyRoutes.getById.compile(params: [id]),
        mapper: (json) => api.entityBuilder.buildCurrency(json),
        errorMap: {
          401: RestrrError.notSignedIn,
          404: RestrrError.notFound,
        });
  }

  Future<RestResponse<bool>> deleteCurrencyById(Id id) async {
    return noResponseRequest(route: CurrencyRoutes.deleteById.compile(params: [id]), errorMap: {
      401: RestrrError.notSignedIn,
      404: RestrrError.notFound,
    });
  }

  Future<RestResponse<Currency>> updateCurrencyById(Id id,
      {String? name, String? symbol, String? isoCode, int? decimalPlaces}) async {
    if (name == null && symbol == null && isoCode == null && decimalPlaces == null) {
      throw ArgumentError('At least one field must be set');
    }
    return request(
        route: CurrencyRoutes.updateById.compile(params: [id]),
        mapper: (json) => api.entityBuilder.buildCurrency(json),
        body: {
          if (name != null) 'name': name,
          if (symbol != null) 'symbol': symbol,
          if (isoCode != null) 'iso_code': isoCode,
          if (decimalPlaces != null) 'decimal_places': decimalPlaces,
        },
        errorMap: {
          401: RestrrError.notSignedIn,
          404: RestrrError.notFound,
        });
  }
}
