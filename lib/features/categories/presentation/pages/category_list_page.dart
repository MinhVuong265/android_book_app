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
        title: const Text('Quản lý danh mục'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () => _showAddEditDialog(context, ref),
          backgroundColor: Colors.white,
          elevation: 8,
          tooltip: 'Add category',
          child: ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [Colors.pink, Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(rect),
            blendMode: BlendMode.srcIn,
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
        ),
      ),
      body: asyncCats.when(
        data: (cats) {
          if (cats.isEmpty) {
            return const Center(child: Text('No categories'));
          }
          // Responsive: use DataTable on wide screens, ListView on small screens
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 700) {
              // Use horizontal scroll when needed, but expand the table/card to fill available width
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  // ensure the inner card expands to at least the available width
                  constraints: BoxConstraints(minWidth: constraints.maxWidth - 24),
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Danh mục')),
                          DataColumn(label: Text('Mô tả')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: cats.map((c) {
                          return DataRow(cells: [
                            DataCell(Text(c.name)),
                            DataCell(ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: Text(
                                c.description,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                            DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showAddEditDialog(context, ref, model: c),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDelete(context, ref, c.id),
                              ),
                            ])),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            }

            // Fallback for small screens: keep ListView for mobile friendliness
            return ListView.separated(
              itemCount: cats.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final c = cats[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(c.name),
                    subtitle: Text(c.description),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAddEditDialog(context, ref, model: c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(context, ref, c.id),
                      ),
                    ]),
                  ),
                );
              },
            );
          });
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, WidgetRef ref, {Category? model}) {
    final nameCtrl = TextEditingController(text: model?.name ?? '');
    final descCtrl = TextEditingController(text: model?.description ?? '');
    DateTime? selectedDate = model?.createdAt;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(model == null ? 'Thêm danh mục' : 'Chỉnh sửa danh mục'),
              content: SizedBox(
                width: 520,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên danh mục')),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Mô tả'), maxLines: 3),
                  const SizedBox(height: 12),
                  // Creation date label + icon + selected date text
                  Row(
                    children: [
                      const Text('Ngày tạo', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          final now = DateTime.now();
                          final firstDate = DateTime(2000);
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate ?? now,
                            firstDate: firstDate,
                            lastDate: DateTime(now.year + 5),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            size: 28,
                            color: Theme.of(ctx).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                              : 'Chưa chọn',
                          style: TextStyle(color: Theme.of(ctx).textTheme.bodyMedium?.color),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Huỷ')),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final desc = descCtrl.text.trim();
                    if (name.isEmpty) return;

                    final ds = ref.read(categoryRemoteDataSourceProvider);

                    try {
                      if (model == null) {
                        // create: id can be empty string; datasource will assign id
                        final newCat = Category(id: '', name: name, description: desc, createdAt: selectedDate);
                        await ds.createCategory(newCat);
                      } else {
                        final updated = Category(id: model.id, name: name, description: desc, createdAt: selectedDate ?? model.createdAt);
                        await ds.updateCategory(updated);
                      }
                      // refresh provider
                      ref.invalidate(categoriesProvider);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(model == null ? 'Created' : 'Updated')),
                      );
                    } catch (e) {
                      // show error
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: Text(model == null ? 'Thêm' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá danh mục'),
        content: const Text('Bạn có chắc muốn xoá danh mục này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () async {
              try {
                final ds = ref.read(categoryRemoteDataSourceProvider);
                await ds.deleteCategory(id);
                ref.invalidate(categoriesProvider);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá danh mục')));
              } catch (e) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }
}