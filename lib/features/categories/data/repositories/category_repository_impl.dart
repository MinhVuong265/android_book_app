import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    // Có thể thêm cache/local sau này
    return remoteDataSource.fetchCategories();
  }

  @override
  Future<Category> createCategory(Category category) async {
    return remoteDataSource.createCategory(category);
  }

  @override
  Future<Category> updateCategory(Category category) async {
    return remoteDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) {
    return remoteDataSource.deleteCategory(id);
  }
}
