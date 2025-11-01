import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  UserRemoteDataSource({required this.firestore});

  /// Lấy toàn bộ người dùng
  Future<List<UserEntity>> fetchUsers() async {
    final querySnapshot = await firestore.collection('users').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;

      final name = (data['name'] ?? '') as String;
      final email = (data['email'] ?? '') as String;

      final phoneNumber = data['phoneNumber'] as String?;
      final address = data['address'] as String?;
      final gender = data['gender'] as String?;

      DateTime? birthDate;
      final rawBirth = data['birthDate'];
      if (rawBirth is Timestamp) {
        birthDate = rawBirth.toDate();
      } else if (rawBirth is String) {
        try {
          birthDate = DateTime.parse(rawBirth);
        } catch (_) {}
      }

      DateTime? createdAt;
      final rawCreated = data['createdAt'];
      if (rawCreated is Timestamp) {
        createdAt = rawCreated.toDate();
      } else if (rawCreated is String) {
        try {
          createdAt = DateTime.parse(rawCreated);
        } catch (_) {}
      }

      return UserEntity(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        gender: gender,
        birthDate: birthDate,
        createdAt: createdAt,
      );
    }).toList();
  }

  /// Lấy thông tin 1 người dùng theo id
  Future<UserEntity?> fetchUserById(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data() ?? {};
    final name = (data['name'] ?? '') as String;
    final email = (data['email'] ?? '') as String;

    final phoneNumber = data['phoneNumber'] as String?;
    final address = data['address'] as String?;
    final gender = data['gender'] as String?;

    DateTime? birthDate;
    final rawBirth = data['birthDate'];
    if (rawBirth is Timestamp) {
      birthDate = rawBirth.toDate();
    } else if (rawBirth is String) {
      try {
        birthDate = DateTime.parse(rawBirth);
      } catch (_) {}
    }

    DateTime? createdAt;
    final rawCreated = data['createdAt'];
    if (rawCreated is Timestamp) {
      createdAt = rawCreated.toDate();
    } else if (rawCreated is String) {
      try {
        createdAt = DateTime.parse(rawCreated);
      } catch (_) {}
    }

    return UserEntity(
      id: doc.id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      gender: gender,
      birthDate: birthDate,
      createdAt: createdAt,
    );
  }

  /// Tìm kiếm theo tên hoặc email
  Future<List<UserEntity>> searchUsers(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return await fetchUsers();
    final all = await fetchUsers();
    return all.where((u) {
      final name = u.name.toLowerCase();
      final email = u.email.toLowerCase();
      return name.contains(q) || email.contains(q);
    }).toList();
  }
}
