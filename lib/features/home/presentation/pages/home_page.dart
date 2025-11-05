import 'package:book_app/core/routing/app_routes.dart';
import 'package:book_app/features/books/presentation/pages/book_detail_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "Tất cả";

  final List<String> _categories = [
    "Tất cả",
    "Tiểu thuyết",
    "Kinh doanh",
    "Tâm lý",
    "Khoa học",
    "Lịch sử",
  ];

  @override
  Widget build(BuildContext context) {
    final booksRef = FirebaseFirestore.instance.collection('books');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔍 Thanh tìm kiếm + Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sách hoặc tác giả...',
                      prefixIcon: const Icon(Icons.search, color: Colors.brown),
                      filled: true,
                      fillColor: Colors.brown.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // 🔁 Dữ liệu sách
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: booksRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final books = snapshot.data?.docs ?? [];

                // ✅ Lọc dữ liệu theo từ khóa & danh mục
                final filteredBooks = books.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data["title"] ?? "").toString().toLowerCase();
                  final author = (data["author"] ?? "")
                      .toString()
                      .toLowerCase();
                  final category = (data["category"] ?? "Khác")
                      .toString()
                      .toLowerCase();

                  final query = _searchController.text.toLowerCase();
                  final matchQuery =
                      title.contains(query) || author.contains(query);

                  final matchCategory =
                      _selectedCategory == "Tất cả" ||
                      category == _selectedCategory.toLowerCase();

                  return matchQuery && matchCategory;
                }).toList();

                if (filteredBooks.isEmpty) {
                  return const Center(child: Text('Không tìm thấy sách nào.'));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredBooks.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.63,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final data =
                          filteredBooks[index].data() as Map<String, dynamic>;
                      final title = data["title"] ?? "No title";
                      final author = data["author"] ?? "Unknown";
                      final rating = data["rating"] ?? 0.0;
                      final image =
                          data["coverImageUrl"] ?? "images/image1.jpg";

                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return BookDetailSheet(
                                bookData: data,
                                isAdmin:
                                    true, // Thay bằng biến phân quyền nếu có
                              );
                            },
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
                                    fit: BoxFit.cover,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              author,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Text("$rating"),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          context.push(AppRoutes.addEditBook);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
        ],
      ),
    );
  }
}
