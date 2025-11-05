
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:book_app/features/books/domain/repositories/book_repository.dart';

class GetBookById {
  final BookRepository repository;
  GetBookById(this.repository);
  Future<BookEntity> call(String id) async {
    return await repository.getBookById(id);
  }
}