class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? gender;
  final String? address;
  final DateTime? birthDate;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.gender,
    this.address,
    this.birthDate,
    this.createdAt,
  });

  /// Avatar letter (first char of name) for UI
  String get avatarLetter => (name.isNotEmpty ? name[0].toUpperCase() : '?');
}
