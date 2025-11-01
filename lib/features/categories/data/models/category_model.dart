import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    super.createdAt,
  });

  /// Chuyển Firestore document thành `CategoryModel`
  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String docId) {
    DateTime? createdAt;

    final rawCreated = data['createdAt'];
    if (rawCreated is Timestamp) {
      createdAt = rawCreated.toDate();
    } else if (rawCreated is String) {
      try {
        createdAt = DateTime.parse(rawCreated);
      } catch (_) {}
    }

    return CategoryModel(
      id: docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: createdAt,
    );
  }

  /// Dùng khi thêm hoặc cập nhật category
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'createdAt':
          createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
