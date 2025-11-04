import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_data_source.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Account> getAccountById(String id) async {
    return await remoteDataSource.getAccountById(id);
  }

  @override
  Future<void> toggleAccountStatus(String id, bool isActive) async {
    await remoteDataSource.toggleAccountStatus(id, isActive);
  }

  @override
  Future<void> createAccount(Account account) async {
    final model = AccountModel(
      id: '', // id tạm thời, Firestore tự sinh
      name: account.name,
      email: account.email,
      password: account.password,
      role: account.role,
      isActive: account.isActive,
    );
    await remoteDataSource.createAccount(model);
  }
}
