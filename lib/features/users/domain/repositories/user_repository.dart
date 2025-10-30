import '../entities/user.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity?> getUserById(String id);
  Future<List<UserEntity>> searchUsers(String query);
}
