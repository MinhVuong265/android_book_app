import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SearchUsers {
  final UserRepository repository;

  SearchUsers(this.repository);

  Future<List<UserEntity>> call(String query) async {
    return await repository.searchUsers(query);
  }
}
