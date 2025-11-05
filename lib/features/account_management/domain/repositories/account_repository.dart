import '../entities/account.dart';

abstract class AccountRepository {
  Future<Account> getAccountById(String id);
  Future<void> toggleAccountStatus(String id, bool isActive);
  Future<void> createAccount(Account account);
}
