import '../entities/book_entity.dart';
import '../repositories/library_repository.dart';

class GetReadingHistory {
  final LibraryRepository repository;
  GetReadingHistory(this.repository);

  Future<List<BookEntity>> call(String userId) {
    return repository.getReadingHistory(userId);
  }
}
