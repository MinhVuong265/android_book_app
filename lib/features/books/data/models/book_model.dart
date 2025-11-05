import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel extends BookEntity{
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.category,
    super.description,
    required super.coverImageUrl,
    required super.content,
    super.publisher,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookModel(
      id: doc.id,
      title: data['title'],
      author: data['author'] ?? 'Đang cập nhật',
      category: data['category'] ?? 'Chưa phân loại',
      description: data['description'] ?? 'Chưa có mô tả',
      coverImageUrl: data['coverImageUrl'] ?? 'https://example.com/default-cover.jpg',
      content: data['content'] ?? 'Đang cập nhật',
      publisher: data['publisher'] ?? 'Đang cập nhật',
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'content': content,
      'publisher': publisher,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}