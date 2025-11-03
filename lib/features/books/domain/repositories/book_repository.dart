
import 'package:book_app/features/books/domain/entities/book_entity.dart';

abstract class BookRepository {
  Future<List<BookEntity>> getBooks();
  Future<BookEntity> getBookById(String id);
  Future<BookEntity> addBook(BookEntity book);
  Future<BookEntity> updateBook(BookEntity book);
  Future<void> deleteBook(String id);
}