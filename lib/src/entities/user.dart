abstract class User {
  int get id;
  String get username;
  String? get email;
  DateTime get createdAt;
  bool get isAdmin;
}

class UserImpl implements User {
  @override
  final int id;
  @override
  final String username;
  @override
  final String? email;
  @override
  final DateTime createdAt;
  @override
  final bool isAdmin;

  const UserImpl({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.isAdmin,
  });
}
