import 'package:book_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/account_model.dart';
import 'account_detail_page.dart';
import '../../data/datasources/account_remote_data_source.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/usecases/get_account_detail.dart';
import '../../domain/usecases/toggle_account_status.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  late AccountRepositoryImpl repository;
  late ToggleAccountStatus toggleStatusUsecase;
  late GetAccountDetail getAccountUsecase;

  List<AccountModel> accounts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AccountRemoteDataSourceImpl(
      FirebaseFirestore.instance,
    );
    repository = AccountRepositoryImpl(remoteDataSource);
    toggleStatusUsecase = ToggleAccountStatus(repository);
    getAccountUsecase = GetAccountDetail(repository);

    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Lấy toàn bộ accounts từ Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .get();
      final fetchedAccounts = querySnapshot.docs
          .map((doc) => AccountModel.fromDocument(doc))
          .toList();

      setState(() {
        accounts = fetchedAccounts;
      });
    } catch (e) {
      debugPrint('Error fetching accounts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleStatus(AccountModel account, bool value) async {
    try {
      await toggleStatusUsecase(account.id, value);
      setState(() {
        // Thay thế phần tử trong danh sách bằng bản sao đã thay đổi isActive
        final idx = accounts.indexWhere((a) => a.id == account.id);
        if (idx != -1) {
          accounts[idx] = account.copyWith(isActive: value);
        }
      });
    } catch (e) {
      debugPrint('Error toggling status: $e');
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Management')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      account.name.isNotEmpty
                          ? account.name
                                .trim()
                                .split(' ')
                                .map((s) => s.isNotEmpty ? s[0] : '')
                                .take(2)
                                .join()
                          : '?',
                    ),
                  ),
                  title: Text(account.name),
                  subtitle: Text(
                    '${account.email} - ${_capitalize(account.role)}',
                  ),
                  trailing: OutlinedButton(
                    onPressed: () => _toggleStatus(account, !account.isActive),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: account.isActive ? Colors.red : Colors.green,
                      side: BorderSide(
                        color: account.isActive ? Colors.red : Colors.green,
                      ),
                    ),
                    child: Text(
                      account.isActive ? 'Khóa' : 'Mở khóa',
                      style: TextStyle(
                        color: account.isActive ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  onTap: () async {
                    // Mở trang chi tiết và truyền callback để cập nhật từ trang con
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AccountDetailPage(
                          account: account,
                          onToggle: _toggleStatus,
                        ),
                      ),
                    );
                    // Sau khi quay về, setState để đảm bảo giao diện được refresh (nếu cần)
                    setState(() {});
                  },
                );
              },
            ),
            bottomNavigationBar: CommonBottomNav(currentIndex: 5),
    );
  }
}
