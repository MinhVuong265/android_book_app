<<<<<<< Updated upstream
=======
import 'package:book_app/widgets/bottom_nav.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category.dart';
import '../../../../core/providers.dart';

// FutureProvider để load danh sách category
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final ds = ref.read(categoryRemoteDataSourceProvider);
  return ds.fetchCategories();
});

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCats = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
=======
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
       ),
>>>>>>> Stashed changes
        title: const Text(
          'Quản lý danh mục',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber.shade700,
        onPressed: () => _showAddEditDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: asyncCats.when(
        data: (cats) {
          if (cats.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có danh mục nào',
                style: TextStyle(color: Colors.brown, fontSize: 16),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Giao diện desktop
              if (constraints.maxWidth > 700) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minWidth: constraints.maxWidth - 24),
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: DataTable(
                          columnSpacing: 24,
                          headingTextStyle: const TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('Tên danh mục')),
                            DataColumn(label: Text('Mô tả')),
                            DataColumn(label: Text('Hành động')),
                          ],
                          rows: cats.map((c) {
                            return DataRow(cells: [
                              DataCell(Text(c.name)),
                              DataCell(Text(
                                c.description,
                                overflow: TextOverflow.ellipsis,
                              )),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_red_eye,
                                        color: Colors.brown),
                                    tooltip: 'Xem chi tiết',
                                    onPressed: () =>
                                        _showDetailDialog(context, c),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.brown),
                                    onPressed: () =>
                                        _showAddEditDialog(context, ref,
                                            model: c),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () =>
                                        _confirmDelete(context, ref, c.id),
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Giao diện mobile
              return ListView.separated(
                itemCount: cats.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final c = cats[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        c.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      subtitle: Text(c.description),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye,
                              color: Colors.brown),
                          onPressed: () => _showDetailDialog(context, c),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.brown),
                          onPressed: () =>
                              _showAddEditDialog(context, ref, model: c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                          onPressed: () =>
                              _confirmDelete(context, ref, c.id),
                        ),
                      ]),
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
          child: Text('Lỗi: $e',
              style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
<<<<<<< Updated upstream
=======
      bottomNavigationBar: const CommonBottomNav(currentIndex: 3),
>>>>>>> Stashed changes
    );
  }

  // 🟤 Hàm xem chi tiết danh mục (giống xem chi tiết người dùng)
  void _showDetailDialog(BuildContext context, Category c) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon danh mục
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.brown[100],
                child: const Icon(Icons.category,
                    color: Colors.white, size: 50),
              ),
              const SizedBox(height: 14),

              // Tên danh mục
              Text(
                c.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                c.description.isNotEmpty
                    ? c.description
                    : 'Không có mô tả',
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
                    _buildInfo(Icons.tag, 'Mã danh mục', c.id),
                    _buildInfo(Icons.text_snippet, 'Tên danh mục', c.name),
                    _buildInfo(Icons.description, 'Mô tả',
                        c.description.isNotEmpty ? c.description : 'Không có'),
                    _buildInfo(
                      Icons.calendar_today,
                      'Ngày tạo',
                      c.createdAt != null
                          ? '${c.createdAt!.day}/${c.createdAt!.month}/${c.createdAt!.year}'
                          : 'Không có',
                    ),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Đóng',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🟤 Widget dòng thông tin
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

  // 🟤 Dialog thêm/sửa danh mục (giữ nguyên)
    // Hộp thoại thêm / chỉnh sửa danh mục
  void _showAddEditDialog(BuildContext context, WidgetRef ref, {Category? model}) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: model?.name ?? '');
    final descCtrl = TextEditingController(text: model?.description ?? '');
    DateTime? selectedDate = model?.createdAt;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              model == null ? 'Thêm danh mục' : 'Chỉnh sửa danh mục',
              style: const TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 520,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tên danh mục',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tên danh mục';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value != null && value.length > 200) {
                          return 'Mô tả không được vượt quá 200 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Ngày tạo:', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate ?? now,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) setState(() => selectedDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.calendar_today, color: Colors.brown),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedDate != null
                                ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                                : 'Chưa chọn',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Huỷ', style: TextStyle(color: Colors.brown)),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, size: 18),
                label: Text(model == null ? 'Thêm' : 'Lưu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final name = nameCtrl.text.trim();
                  final desc = descCtrl.text.trim();
                  final ds = ref.read(categoryRemoteDataSourceProvider);

                  try {
                    if (model == null) {
                      await ds.createCategory(Category(
                        id: '',
                        name: name,
                        description: desc,
                        createdAt: selectedDate,
                      ));
                    } else {
                      await ds.updateCategory(Category(
                        id: model.id,
                        name: name,
                        description: desc,
                        createdAt: selectedDate ?? model.createdAt,
                      ));
                    }

                    ref.invalidate(categoriesProvider);
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(model == null
                            ? 'Đã thêm danh mục thành công'
                            : 'Đã cập nhật danh mục'),
                        backgroundColor: Colors.amber.shade700,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi: $e'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }


    // Hộp thoại xác nhận xóa danh mục
  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xoá danh mục',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xoá danh mục này không?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Huỷ', style: TextStyle(color: Colors.brown)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Xoá'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              final ds = ref.read(categoryRemoteDataSourceProvider);

              try {
                await ds.deleteCategory(id);
                ref.invalidate(categoriesProvider);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Đã xoá danh mục'),
                    backgroundColor: Colors.amber.shade700,
                  ),
                );
              } catch (e) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi khi xoá: $e'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
