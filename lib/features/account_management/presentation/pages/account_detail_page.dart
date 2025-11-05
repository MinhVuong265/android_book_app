import 'package:flutter/material.dart';
import '../../data/models/account_model.dart';

class AccountDetailPage extends StatefulWidget {
  final AccountModel account;
  final Future<void> Function(AccountModel account, bool value) onToggle;

  const AccountDetailPage({
    Key? key,
    required this.account,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  late AccountModel account;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    account = widget.account;
  }

  Future<void> _handleToggle(bool value) async {
    setState(() {
      isProcessing = true;
      account = account.copyWith(isActive: value);
    });
    try {
      await widget.onToggle(widget.account, value);
    } catch (e) {
      // Nếu thất bại, revert lại trạng thái và thông báo
      setState(() {
        account = account.copyWith(isActive: !value);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật trạng thái: $e')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết tài khoản')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            Text(account.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Email', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            Text(account.email, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text('Role', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            Text(account.role, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                    Text(account.isActive ? 'Đang hoạt động' : 'Đã khóa', style: const TextStyle(fontSize: 16)),
                  ],
                ),
                isProcessing
                    ? const SizedBox(width: 120, height: 40, child: Center(child: CircularProgressIndicator()))
                    : OutlinedButton(
                        onPressed: () => _handleToggle(!account.isActive),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          foregroundColor: account.isActive ? Colors.red : Colors.green,
                          side: BorderSide(
                            color: account.isActive ? Colors.red : Colors.green,
                          ),
                        ),
                        child: Text(
                          account.isActive ? 'Khóa tài khoản' : 'Mở khóa tài khoản',
                          style: TextStyle(
                            color: account.isActive ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
