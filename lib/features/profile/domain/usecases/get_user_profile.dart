import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository repository;
  GetUserProfile(this.repository);

  Future<UserEntity?> call({String? uid}) =>
      repository.getUserProfile(uid: uid);
}
