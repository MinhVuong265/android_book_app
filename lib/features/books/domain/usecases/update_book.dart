
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:book_app/features/books/domain/repositories/book_repository.dart';

class UpdateBook {
  final BookRepository repository;
  UpdateBook(this.repository);
  Future<BookEntity> call(BookEntity book) async {
    return await repository.updateBook(book);
  }
}