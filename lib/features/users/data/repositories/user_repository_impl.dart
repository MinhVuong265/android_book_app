import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> getUsers() async {
    return remoteDataSource.fetchUsers();
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    return await remoteDataSource.fetchUserById(id);
  }

  @override
  Future<List<UserEntity>> searchUsers(String query) async {
    return await remoteDataSource.searchUsers(query);
  }
}
