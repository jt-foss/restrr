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

class RestrrOptions {
  const RestrrOptions();
}

enum SessionInitType { refresh, login, register }

class RestrrBuilder {
  final SessionInitType sessionInitType;
  final Uri hostUri;
  String? sessionId;
  String? username;
  String? password;
  String? mfaCode;

  RestrrOptions options = RestrrOptions();

  RestrrBuilder.refresh({required this.hostUri, required this.sessionId})
      : sessionInitType = SessionInitType.refresh;

  RestrrBuilder.login(
      {required this.hostUri,
      required this.username,
      required this.password,
      this.mfaCode})
      : sessionInitType = SessionInitType.login;

  Future<RestResponse<RestrrImpl>> create() async {
    Restrr.log.info(
        'Attempting to initialize a session (${sessionInitType.name}) with $hostUri');
    final RestResponse<HealthResponse> statusResponse =
        await Restrr.checkUri(hostUri);
    if (!statusResponse.hasData) {
      Restrr.log.warning('Invalid financrr URI: $hostUri');
      return RestrrError.invalidUri.toRestResponse();
    }
    Restrr.hostInformation = Restrr.hostInformation.copyWith(
        hostUri: hostUri, apiVersion: statusResponse.data!.apiVersion);
    Restrr.log.info(
        'Updated host information: $hostUri, API v${statusResponse.data!.apiVersion}');
    final bool success = await switch (sessionInitType) {
      SessionInitType.refresh => throw UnimplementedError(),
      SessionInitType.register => throw UnimplementedError(),
      SessionInitType.login => _handleLogin(username!, password!),
    };
    if (!success) {
      return RestrrError.invalidCredentials.toRestResponse();
    }
    final RestResponse<User> userResponse = await UserService.getSelf();
    Restrr.log.info(userResponse.hasData);
    if (!userResponse.hasData) {
      return RestrrError.invalidCredentials.toRestResponse();
    }
    return RestResponse(data: RestrrImpl._(selfUser: userResponse.data!));
  }

  Future<bool> _handleLogin(String username, String password) async {
    final RestResponse<bool> response =
        await UserService.login(username, password);
    return response.hasData && response.data!;
  }
}

abstract class Restrr {
  static final Logger log = Logger('Restrr');
  static HostInformation hostInformation = HostInformation.empty();

  /// Getter for the [EntityBuilder] of this [Restrr] instance.
  EntityBuilder get entityBuilder;

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

  final User selfUser;
}
