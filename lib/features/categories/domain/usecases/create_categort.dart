import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
	final CategoryRepository repository;

	CreateCategory(this.repository);

	Future<Category> call(Category category) async {
		return await repository.createCategory(category);
	}
}

// NOTE: filename has a typo (create_categort.dart). Consider renaming to
// `create_category.dart` to keep naming consistent across the project.
