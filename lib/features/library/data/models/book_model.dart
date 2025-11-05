import '../../domain/entities/book_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel extends BookEntity {
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.description,
    required super.publisher,
    required super.coverImageUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookModel(
      id: id,
      title: data['title'],
      author: data['author'],
      description: data['description'],
      publisher: data['publisher'],
      coverImageUrl: data['coverImageUrl'],
      // `reading_history` stores `lastRead` instead of createdAt/updatedAt.
      // Be defensive: prefer createdAt/updatedAt, fall back to lastRead, finally DateTime.now()
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : data['lastRead'] != null
              ? (data['lastRead'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : data['lastRead'] != null
              ? (data['lastRead'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }
}
