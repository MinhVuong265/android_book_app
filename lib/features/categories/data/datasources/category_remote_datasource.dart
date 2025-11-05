
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/category.dart';

class CategoryRemoteDataSource {
  final FirebaseFirestore firestore;
  CategoryRemoteDataSource({required this.firestore});

  /// Lấy danh sách tất cả category (trả về domain `Category`)
  Future<List<Category>> fetchCategories() async {
    final querySnapshot = await firestore.collection('categories').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      final name = (data['name'] ?? '') as String;
      final description = (data['description'] ?? '') as String;
      // createdAt may be stored as a Firestore Timestamp or as a String
      DateTime? createdAt;
      final rawCreated = data['createdAt'];
      if (rawCreated is Timestamp) {
        createdAt = rawCreated.toDate();
      } else if (rawCreated is String) {
        try {
          createdAt = DateTime.parse(rawCreated);
        } catch (_) {
          createdAt = null;
        }
      }

      return Category(id: id, name: name, description: description, createdAt: createdAt);
    }).toList();
  }

  /// Tạo category mới
  Future<Category> createCategory(Category category) async {
    final Map<String, Object?> data = {
      'name': category.name,
      'description': category.description,
      // if createdAt provided, store as Timestamp, otherwise use server timestamp
      'createdAt': category.createdAt != null ? Timestamp.fromDate(category.createdAt!) : FieldValue.serverTimestamp(),
    };
    final docRef = await firestore.collection('categories').add(data);
    final newDoc = await docRef.get();
    final createdData = newDoc.data() ?? {};
    final id = newDoc.id;
    final name = (createdData['name'] ?? '') as String;
    final description = (createdData['description'] ?? '') as String;
    // map createdAt if available
    DateTime? createdAt;
    final rawCreated = createdData['createdAt'];
    if (rawCreated is Timestamp) {
      createdAt = rawCreated.toDate();
    } else if (rawCreated is String) {
      try {
        createdAt = DateTime.parse(rawCreated);
      } catch (_) {
        createdAt = null;
      }
    }

    return Category(id: id, name: name, description: description, createdAt: createdAt);
  }

  /// Cập nhật category
  Future<Category> updateCategory(Category category) async {
    final Map<String, Object?> data = {
      'name': category.name,
      'description': category.description,
      // allow updating createdAt if provided (store as Timestamp), otherwise do not change it
      if (category.createdAt != null) 'createdAt': Timestamp.fromDate(category.createdAt!),
    };
    await firestore.collection('categories').doc(category.id).update(data);
    return category;
  }

  /// Xóa category
  Future<void> deleteCategory(String id) async {
    await firestore.collection('categories').doc(id).delete();
  }
}
