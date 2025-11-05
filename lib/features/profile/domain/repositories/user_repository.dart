import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUserProfile({String? uid});
  Future<void> updateUserProfile(UserEntity user);
}
