import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../../../core/providers.dart';

// FutureProvider to load users
final usersProvider = FutureProvider<List<UserEntity>>((ref) async {
  final ds = ref.read(userRemoteDataSourceProvider);
  return ds.fetchUsers();
});

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncUsers = ref.watch(usersProvider);
    final query = _searchCtrl.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc email',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ),
      body: asyncUsers.when(
        data: (users) {
          final filtered = query.isEmpty
              ? users
              : users.where((u) {
                  final name = u.name.toLowerCase();
                  final email = u.email.toLowerCase();
                  return name.contains(query) || email.contains(query);
                }).toList();

          if (filtered.isEmpty) return const Center(child: Text('No users'));

          return ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final u = filtered[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(u.name),
                  subtitle: Text(u.email),
                  onTap: () => _showDetailDialog(context, u),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, UserEntity u) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(u.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${u.email}'),
            const SizedBox(height: 8),
            Text('Ngày tạo: ${u.createdAt != null ? '${u.createdAt!.year}-${u.createdAt!.month.toString().padLeft(2, '0')}-${u.createdAt!.day.toString().padLeft(2, '0')}' : 'Không có'}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Đóng'))],
      ),
    );
  }
}

