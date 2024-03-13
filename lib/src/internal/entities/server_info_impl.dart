
import 'package:restrr/restrr.dart';

class ServerInfoImpl implements ServerInfo {
  @override
  final bool healthy;
  @override
  final int apiVersion;
  @override
  final String? details;

  const ServerInfoImpl({
    required this.healthy,
    required this.apiVersion,
    required this.details,
  });
}
