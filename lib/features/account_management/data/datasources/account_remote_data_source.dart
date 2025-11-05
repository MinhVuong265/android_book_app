import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/account_model.dart';

abstract class AccountRemoteDataSource {
  Future<AccountModel> getAccountById(String id);
  Future<void> toggleAccountStatus(String id, bool isActive);
  Future<void> createAccount(AccountModel account);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final FirebaseFirestore firestore;

  AccountRemoteDataSourceImpl(this.firestore);

  CollectionReference get accountsRef => firestore.collection('accounts');

  @override
  Future<AccountModel> getAccountById(String id) async {
    final doc = await accountsRef.doc(id).get();
    return AccountModel.fromDocument(doc);
  }

  @override
  Future<void> toggleAccountStatus(String id, bool isActive) async {
    await accountsRef.doc(id).update({'isActive': isActive});
  }

  @override
  Future<void> createAccount(AccountModel account) async {
    await accountsRef.add(account.toMap());
  }
}
