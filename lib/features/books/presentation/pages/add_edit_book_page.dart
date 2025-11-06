import 'package:book_app/features/books/presentation/pages/book_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/book_repository_impl.dart';
import '../../data/datasources/firebase_book_datasource.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/usecases/create_book.dart';
import '../../domain/usecases/update_book.dart'; // ✅ thêm usecase update

class AddEditBookPage extends StatefulWidget {
  final BookEntity? book; // nếu null -> thêm, nếu có -> sửa
  const AddEditBookPage({super.key, this.book});

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _repo = BookRepositoryImpl(FirebaseBookDatasource());
  final _categoriesRef = FirebaseFirestore.instance.collection('categories');

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _contentController.text = widget.book!.content;
      _imageController.text = widget.book!.coverImageUrl;
      _descriptionController.text = widget.book!.description ?? '';
      _selectedCategory = widget.book!.category;
    }
  }

  Future<void> _saveBook() async {
    if (_titleController.text.trim().isEmpty ||
        _authorController.text.trim().isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    final newBook = BookEntity(
      id: widget.book?.id ?? '',
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      description: _descriptionController.text.trim(),
      content: _contentController.text.trim(),
      coverImageUrl: _imageController.text.trim().isEmpty
          ? 'images/image1.jpg'
          : _imageController.text.trim(),
      category: _selectedCategory!,
      createdAt: widget.book?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.book == null) {
        
        final createBook = CreateBook(_repo);
        await createBook(newBook);
      } else {
        
        final updateBook = UpdateBook(_repo);
        await updateBook(newBook);
      }

      if (!mounted) return;

      // 🔁 Sau khi lưu → hiển thị chi tiết sách
      Navigator.pop(context, true);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => BookDetailSheet(
          bookData: {
            'id': newBook.id,
            'title': newBook.title,
            'author': newBook.author,
            'content': newBook.content,
            'coverImageUrl': newBook.coverImageUrl,
            'category': newBook.category,
          },
          isAdmin: true,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi lưu sách: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Sửa sách' : 'Thêm sách'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Tác giả'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
              minLines: 2,
              maxLines: 5,
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Nội dung'),
              minLines: 5,
              maxLines: 10,
            ),
            const SizedBox(height: 16),

            // 🔽 Dropdown danh mục
            StreamBuilder<QuerySnapshot>(
              stream: _categoriesRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text("Không thể tải danh mục");
                }

                final docs = snapshot.data?.docs ?? [];
                final categories =
                    docs.map((d) => d['name'].toString()).toList();

                if (categories.isEmpty) {
                  return const Text("Chưa có danh mục nào trong Firestore");
                }

                return DropdownButtonFormField<String>(
                  value: _selectedCategory ?? categories[0],
                  items: categories
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                );
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _saveBook,
              child: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
            ),
          ],
        ),
      ),
    );
  }
}
