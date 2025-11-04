class Account {
  final String name;
  final String email;
  final String password;
  final String role; // "admin" hoặc "reader"
  final bool isActive;

  Account({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.isActive,
  });
}
