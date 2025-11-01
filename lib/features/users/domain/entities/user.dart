class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? gender;
  final DateTime? birthDate;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.address,
    this.gender,
    this.birthDate,
    this.createdAt,
  });
}
