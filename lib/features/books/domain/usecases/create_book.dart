import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:book_app/features/books/domain/repositories/book_repository.dart';

class CreateBook {
  final BookRepository repository;
  CreateBook(this.repository);
  Future<BookEntity> call(BookEntity book) async {
    return await repository.addBook(book);
  }
}