import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_remote_data_source.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource dataSource;

  LibraryRepositoryImpl(this.dataSource);

  @override
  Future<List<BookEntity>> getFavoriteBooks(String userId) {
    return dataSource.getFavoriteBooks(userId);
  }

  @override
  Future<List<BookEntity>> getReadingHistory(String userId) {
    return dataSource.getReadingHistory(userId);
  }
}
