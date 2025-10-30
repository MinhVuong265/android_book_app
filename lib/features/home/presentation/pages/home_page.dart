import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      {
        "title": "Forty Rules of Love",
        "author": "Elif Shafak",
        "rating": 5.0,
        "image": "  assets/images/book_images.jpg",
      },
      {
        "title": "Tangled",
        "author": "Alessandro Ferrari",
        "rating": 4.0,
        "image": "https://m.media-amazon.com/images/I/61qX3v-Mq8L.jpg",
      },
      {
        "title": "Namal",
        "author": "Nimra Ahmad",
        "rating": 5.0,
        "image": "https://m.media-amazon.com/images/I/61okJ6Q8WyL.jpg",
      },
      {
        "title": "EGO is the ENEMY",
        "author": "Ryan Holiday",
        "rating": 4.5,
        "image": "https://m.media-amazon.com/images/I/71Xb9+vSDrL.jpg",
      },
    ];

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
      body: SingleChildScrollView(
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: GridView.builder(
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
                final book = books[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'images/image1.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${book["title"]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${book["author"]}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Text("${book["rating"]}"),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                );
              },
            ),
            ),     
            const SizedBox(height: 20),
            const Text(
              "People with similar interests also like",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 80),
          ],
        ),
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
