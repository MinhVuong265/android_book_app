import 'package:book_app/core/routing/app_routes.dart';
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookDetailSheet extends StatelessWidget {
  final Map<String, dynamic> bookData;
  final bool isAdmin;

  const BookDetailSheet({
    super.key,
    required this.bookData,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final id = bookData['id'] ?? '';
    final title = bookData['title'] ?? 'Không có tên';
    final author = bookData['author'] ?? 'Không rõ tác giả';
    final image = bookData['coverImageUrl'] ?? 'images/image1.jpg';
    final content = bookData['content'] ?? 'Chưa có nội dung';

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh bìa
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: image.startsWith('http')
                        ? Image.network(image, height: 200)
                        : Image.asset('images/image1.jpg', height: 200),
                  ),
                ),
                const SizedBox(height: 16),

                // Tiêu đề & tác giả
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tác giả: $author',
                  style: const TextStyle(color: Colors.grey),
                ),

                const Divider(height: 30),

                // Nội dung ngắn
                Text(
                  content.length > 200
                      ? '${content.substring(0, 200)}...'
                      : content,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),

                const SizedBox(height: 25),

                // Các nút chức năng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(
                          AppRoutes.readBook,
                          extra:  BookEntity(
                            id : id,
                            title: title,
                            author: author,
                            content : content,
                            coverImageUrl: image,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          )
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Đọc sách'),
                    ),

                    if (true)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                          AppRoutes.addEditBook,
                          extra:  BookEntity(
                            id : id,
                            title: title,
                            author: author,
                            content : content,
                            coverImageUrl: image,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          )
                        );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Sửa'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
