import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String name,
    required String email,
    String? phoneNumber,
    String? gender,
    String? address,
    DateTime? birthDate,
    DateTime? createdAt,
  }) : super(
         id: id,
         name: name,
         email: email,
         phoneNumber: phoneNumber,
         gender: gender,
         address: address,
         birthDate: birthDate,
         createdAt: createdAt,
       );

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    Timestamp? tsBirth = data['birthDate'] is Timestamp
        ? data['birthDate'] as Timestamp
        : null;
    Timestamp? tsCreated = data['createdAt'] is Timestamp
        ? data['createdAt'] as Timestamp
        : null;

    return UserModel(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      phoneNumber: data['phoneNumber'] as String?,
      gender: data['gender'] as String?,
      address: data['address'] as String?,
      birthDate: tsBirth?.toDate(),
      createdAt: tsCreated?.toDate(),
    );
  }

  Map<String, dynamic> toMapForUpdate() {
    final map = <String, dynamic>{'name': name, 'email': email};
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (gender != null) map['gender'] = gender;
    if (address != null) map['address'] = address;
    if (birthDate != null) map['birthDate'] = Timestamp.fromDate(birthDate!);
    // do not overwrite createdAt here
    return map;
  }
}
