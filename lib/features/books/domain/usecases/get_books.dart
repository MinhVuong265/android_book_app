
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:book_app/features/books/domain/repositories/book_repository.dart';

class GetBooks {
  final BookRepository repository;
  GetBooks(this.repository);
  Future<List<BookEntity>> call() async {
    return await repository.getBooks();
  }
}