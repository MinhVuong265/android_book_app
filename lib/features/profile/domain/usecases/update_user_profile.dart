import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  Future<void> call(UserEntity user) => repository.updateUserProfile(user);
}
