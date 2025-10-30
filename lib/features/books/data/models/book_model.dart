import 'package:book_app/features/books/domain/entities/book_entity.dart';

class BookModel extends BookEntity{
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    super.description,
    required super.coverImageUrl,
    super.publisher,
    required super.createdAt,
    required super.updatedAt,
  })

}