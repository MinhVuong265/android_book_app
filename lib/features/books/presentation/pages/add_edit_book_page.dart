import 'package:flutter/material.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../data/datasources/firebase_book_datasource.dart';
import '../../domain/entities/book_entity.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _contentController.text = widget.book!.content;
      _imageController.text = widget.book!.coverImageUrl;
      _descriptionController.text = widget.book!.description ?? '';
    }
  }

  Future<void> _saveBook() async {
    final newBook = BookEntity(
      id: widget.book?.id ?? '',
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      content: _contentController.text.trim(),
      coverImageUrl: _imageController.text.trim(),
      createdAt: widget.book?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.book == null) {
      await _repo.addBook(newBook);
    } else {
      await _repo.updateBook(newBook);
    }

    if (mounted) {
      Navigator.pop(context, true); // trở lại home sau khi lưu
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Sửa sách' : 'Thêm sách'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBook,
              child: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
            ),
          ],
        ),
      ),
    );
  }
}
