import '../entities/account.dart';
import '../repositories/account_repository.dart';

class GetAccountDetail {
  final AccountRepository repository;

  GetAccountDetail(this.repository);

  Future<Account> call(String id) async {
    return await repository.getAccountById(id);
  }
}
