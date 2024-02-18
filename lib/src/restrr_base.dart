import 'package:logging/logging.dart';

import '../restrr.dart';

class HostInformation {
  final Uri? hostUri;
  final int apiVersion;

  bool get hasHostUrl => hostUri != null;

  const HostInformation({required this.hostUri, this.apiVersion = 1});

  const HostInformation.empty()
      : hostUri = null,
        apiVersion = -1;

  HostInformation copyWith({Uri? hostUri, int? apiVersion}) {
    return HostInformation(
      hostUri: hostUri ?? this.hostUri,
      apiVersion: apiVersion ?? this.apiVersion,
    );
  }
}

enum SessionInitType { login, register }

class RestrrBuilder {
  final SessionInitType sessionInitType;
  final Uri uri;
  String? sessionId;
  String? username;
  String? password;
  String? mfaCode;

  RestrrBuilder.login(
      {required this.uri, required this.username, required this.password})
      : sessionInitType = SessionInitType.login;

  Future<RestResponse<RestrrImpl>> create() async {
    Restrr.log.info(
        'Attempting to initialize a session (${sessionInitType.name}) with $uri');
    final RestResponse<HealthResponse> statusResponse =
        await Restrr.checkUri(uri);
    if (!statusResponse.hasData) {
      Restrr.log.warning('Invalid financrr URI: $uri');
      return RestrrError.invalidUri.toRestResponse();
    }
    Restrr.log.info(
        'Updated host information: $uri, API v${statusResponse.data!.apiVersion}');
    final RestrrImpl? api = await switch (sessionInitType) {
      SessionInitType.register => throw UnimplementedError(),
      SessionInitType.login => _handleLogin(username!, password!),
    };
    if (api == null) {
      return RestrrError.invalidCredentials.toRestResponse();
    }
    return RestResponse(data: api);
  }

  Future<RestrrImpl?> _handleLogin(String username, String password) async {
    final RestResponse<bool> response =
        await UserService.login(username, password);
    if (!response.hasData) {
      return null;
    }
    final RestResponse<User> userResponse = await UserService.getSelf();
    if (!userResponse.hasData) {
      return null;
    }
    return RestrrImpl._(selfUser: userResponse.data!);
  }
}

abstract class Restrr {
  static final Logger log = Logger('Restrr');
  static HostInformation hostInformation = HostInformation.empty();

  /// Getter for the [EntityBuilder] of this [Restrr] instance.
  EntityBuilder get entityBuilder;

  /// The currently authenticated user.
  User get selfUser;

  static Future<RestResponse<HealthResponse>> checkUri(Uri uri) async {
    hostInformation = hostInformation.copyWith(hostUri: uri, apiVersion: -1);
    return ApiService.request(
            route: StatusRoutes.health.compile(),
            mapper: (json) => EntityBuilder.buildHealthResponse(json))
        .then((response) {
      if (response.hasData && response.data!.healthy) {
        hostInformation =
            hostInformation.copyWith(apiVersion: response.data!.apiVersion);
      }
      return response;
    });
  }
}

class RestrrImpl implements Restrr {
  RestrrImpl._({required this.selfUser});

  @override
  late final EntityBuilder entityBuilder = EntityBuilder(api: this);

  @override
  final User selfUser;
}
