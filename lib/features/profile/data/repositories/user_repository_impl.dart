import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl({required this.remote});

  @override
  Future<UserEntity?> getUserProfile({String? uid}) async {
    final model = await remote.getUserByUid(uid: uid);
    return model;
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    final model = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      gender: user.gender,
      address: user.address,
      birthDate: user.birthDate,
      createdAt: user.createdAt,
    );
    await remote.updateUser(model);
  }
}
