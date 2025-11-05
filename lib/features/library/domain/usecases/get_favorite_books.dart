import '../entities/book_entity.dart';
import '../repositories/library_repository.dart';

class GetFavoriteBooks {
  final LibraryRepository repository;
  GetFavoriteBooks(this.repository);

  Future<List<BookEntity>> call(String userId) {
    return repository.getFavoriteBooks(userId);
  }
}
