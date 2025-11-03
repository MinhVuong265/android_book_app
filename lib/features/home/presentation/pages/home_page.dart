import 'package:book_app/core/routing/app_routes.dart';
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:book_app/features/books/presentation/pages/book_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final booksRef = FirebaseFirestore.instance.collection('books');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.search, color: Colors.brown),
          SizedBox(width: 10),
          Icon(Icons.grid_view, color: Colors.brown),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: booksRef.snapshots(),
        builder: (context, snapshot) {
          // 🕒 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Lỗi
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          // ✅ Lấy danh sách
          final books = snapshot.data?.docs ?? [];

          if (books.isEmpty) {
            return const Center(child: Text('Chưa có sách nào.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Top Pick for You",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.63,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final data = books[index].data() as Map<String, dynamic>;

                    final title = data["title"] ?? "No title";
                    final author = data["author"] ?? "Unknown";
                    final rating = data["rating"] ?? 0.0;
                    final image = data["image"] ?? "";

                    return GestureDetector(
                      onTap: () {
                        // Ví dụ: điều hướng đến trang đọc sách
                      final data = books[index].data() as Map<String, dynamic>;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return BookDetailSheet(
                              bookData: data,
                              // isAdmin: true, // 👈 nếu bạn có biến phân quyền thì thay vào đây
                            );
                          },                        
                        // context.push(
                        //   AppRoutes.readBook,
                        //   extra:  BookEntity(
                        //     id : books[index].id,
                        //     title: title,
                        //     author: author,
                        //     content : data["content"] ?? "",
                        //     coverImageUrl: data["coverImageUrl"] ?? "",
                        //     createdAt: DateTime.now(),
                        //     updatedAt: DateTime.now(),
                        //   )
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: //image.startsWith('http')
                                // ? Image.network(
                                //     image,
                                //     height: 200,
                                //     width: double.infinity,
                                //     fit: BoxFit.cover,
                                //   )
                                 Image.asset(
                                    'images/image1.jpg',
                                    height: 300,
                                    width: 200,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            author,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text("$rating"),
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "People with similar interests also like",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          context.push(AppRoutes.addEditBook); // hoặc mở dialog thêm sách
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Explore đang được chọn
        onTap: (index) {
          if (index == 0) context.go('/collection');
          if (index == 1) context.go('/explore');
          if (index == 2) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
        ],
      ),
    );
  }
}
