import '../repositories/account_repository.dart';

class ToggleAccountStatus {
  final AccountRepository repository;

  ToggleAccountStatus(this.repository);

  Future<void> call(String id, bool isActive) async {
    await repository.toggleAccountStatus(id, isActive);
  }
}
