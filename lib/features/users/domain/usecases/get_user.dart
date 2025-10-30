import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<UserEntity?> call(String id) async {
    return await repository.getUserById(id);
  }
}
