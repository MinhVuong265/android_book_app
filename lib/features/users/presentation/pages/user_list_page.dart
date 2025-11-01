import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../../../core/providers.dart';

// Provider load danh sách người dùng
final usersProvider = FutureProvider<List<UserEntity>>((ref) async {
  final ds = ref.read(userRemoteDataSourceProvider);
  return ds.fetchUsers();
});

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(usersProvider);
    final searchCtrl = TextEditingController();
    ValueNotifier<String> query = ValueNotifier('');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý người dùng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc email...',
                prefixIcon: const Icon(Icons.search, color: Colors.brown),
                filled: true,
                fillColor: const Color(0xFFFFFCF9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => query.value = value.trim().toLowerCase(),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: query,
        builder: (context, value, _) {
          return asyncUsers.when(
            data: (users) {
              final filtered = value.isEmpty
                  ? users
                  : users.where((u) {
                      final name = u.name.toLowerCase();
                      final email = u.email.toLowerCase();
                      return name.contains(value) || email.contains(value);
                    }).toList();

              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    'Không có người dùng nào',
                    style: TextStyle(color: Colors.brown, fontSize: 16),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Giao diện dạng bảng nếu rộng (desktop)
                  if (constraints.maxWidth > 700) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth - 24),
                        child: Card(
                          margin: const EdgeInsets.all(12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: DataTable(
                              columnSpacing: 24,
                              headingTextStyle: const TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(label: Text('Tên người dùng')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Số điện thoại')),
                                DataColumn(label: Text('Giới tính')),
                                DataColumn(label: Text('Địa chỉ')),
                                DataColumn(label: Text('Ngày tạo')),
                                DataColumn(label: Text('')), // Cột trống để chứa icon
                              ],
                              rows: filtered.map((u) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(u.name)),
                                    DataCell(Text(u.email)),
                                    DataCell(Text(u.phoneNumber ?? '-')),
                                    DataCell(Text(u.gender ?? '-')),
                                    DataCell(Text(u.address ?? '-')),
                                    DataCell(Text(
                                      u.createdAt != null
                                          ? '${u.createdAt!.year}-${u.createdAt!.month.toString().padLeft(2, '0')}-${u.createdAt!.day.toString().padLeft(2, '0')}'
                                          : '-',
                                    )),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.remove_red_eye, color: Colors.brown),
                                        tooltip: 'Xem chi tiết',
                                        onPressed: () => _showDetailDialog(context, u),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  // Giao diện dạng danh sách (mobile)
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final u = filtered[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            u.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          subtitle: Text(u.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: Colors.brown),
                            onPressed: () => _showDetailDialog(context, u),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            ),
            error: (e, st) => Center(
              child: Text('Lỗi: $e', style: const TextStyle(color: Colors.redAccent)),
            ),
          );
        },
      ),
    );
  }

  // void _showDetailDialog(BuildContext context, UserEntity u) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       backgroundColor: const Color(0xFFFFFEFC),
  //       title: Text(
  //         u.name,
  //         style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildInfo('Email', u.email),
  //           _buildInfo('Số điện thoại', u.phoneNumber ?? 'Chưa có'),
  //           _buildInfo('Địa chỉ', u.address ?? 'Chưa có'),
  //           _buildInfo('Giới tính', u.gender ?? 'Chưa có'),
  //           _buildInfo(
  //             'Ngày sinh',
  //             u.birthDate != null
  //                 ? '${u.birthDate!.day}/${u.birthDate!.month}/${u.birthDate!.year}'
  //                 : 'Chưa có',
  //           ),
  //           _buildInfo(
  //             'Ngày tạo',
  //             u.createdAt != null
  //                 ? '${u.createdAt!.day}/${u.createdAt!.month}/${u.createdAt!.year}'
  //                 : 'Không có',
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(ctx).pop(),
  //           child: const Text('Đóng', style: TextStyle(color: Colors.brown)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildInfo(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: RichText(
  //       text: TextSpan(
  //         text: '$label: ',
  //         style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
  //         children: [
  //           TextSpan(
  //             text: value,
  //             style: const TextStyle(color: Colors.black87),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
    void _showDetailDialog(BuildContext context, UserEntity u) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ảnh đại diện
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.brown[100],
                child: const Icon(Icons.person, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 14),

              // Tên + Email
              Text(
                u.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                u.email,
                style: TextStyle(color: Colors.grey[700]),
              ),

              const SizedBox(height: 20),
              const Divider(),

              // Thông tin chi tiết
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo(Icons.phone, 'Số điện thoại', u.phoneNumber ?? 'Chưa có'),
                    _buildInfo(Icons.home, 'Địa chỉ', u.address ?? 'Chưa có'),
                    _buildInfo(Icons.wc, 'Giới tính', u.gender ?? 'Chưa có'),
                    _buildInfo(Icons.cake, 'Ngày sinh', u.birthDate != null
                        ? '${u.birthDate!.day}/${u.birthDate!.month}/${u.birthDate!.year}'
                        : 'Chưa có'),
                    _buildInfo(Icons.calendar_today, 'Ngày tạo', u.createdAt != null
                        ? '${u.createdAt!.day}/${u.createdAt!.month}/${u.createdAt!.year}'
                        : 'Không có'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Đóng', style: TextStyle(color: Colors.white)),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown[400]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.brown)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
