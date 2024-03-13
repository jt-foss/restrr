import 'package:restrr/src/internal/entities/restrr_entity_impl.dart';

import '../../../restrr.dart';

class UserImpl extends RestrrEntityImpl implements User {
  @override
  final String username;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final DateTime createdAt;
  @override
  final bool isAdmin;

  const UserImpl({
    required super.api,
    required super.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.isAdmin,
  });

  @override
  String get effectiveDisplayName => displayName ?? username;
}
