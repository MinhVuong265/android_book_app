import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:book_app/core/routing/app_routes.dart';
import 'favorite_books_page.dart';
import 'reading_history_page.dart';

class MyCollectionPage extends StatelessWidget {
  final String userName;

  const MyCollectionPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final didPop = await Navigator.of(context).maybePop();
            if (!didPop) context.go(AppRoutes.home);
          },
        ),
        title: const Text("My Collection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text("Favorite Books"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteBooksPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text("Reading History"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReadingHistoryPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
