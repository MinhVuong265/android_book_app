import '../../domain/entities/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel extends Account {
  final String id; // chỉ dùng trong app, không lưu Firestore

  AccountModel({
    required this.id,
    required String name,
    required String email,
    required String password,
    required String role,
    required bool isActive,
  }) : super(
         name: name,
         email: email,
         password: password,
         role: role,
         isActive: isActive,
       );

  factory AccountModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AccountModel(
      id: doc.id, // lấy từ DocumentSnapshot
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? 'reader',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'isActive': isActive,
    };
  }

  /// Trả về một bản sao của model, cho phép thay đổi các trường tùy chọn.
  AccountModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    bool? isActive,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
