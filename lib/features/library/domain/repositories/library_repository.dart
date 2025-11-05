import '../entities/book_entity.dart';

abstract class LibraryRepository {
  Future<List<BookEntity>> getFavoriteBooks(String userId);
  Future<List<BookEntity>> getReadingHistory(String userId);
}
