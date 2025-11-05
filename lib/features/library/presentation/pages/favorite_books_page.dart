import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/usecases/get_favorite_books.dart';
import '../../data/datasources/library_remote_data_source.dart';
import '../../data/repositories/library_repository_impl.dart';

class FavoriteBooksPage extends StatelessWidget {
  const FavoriteBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Books")),
      body: Builder(
        builder: (context) {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) {
            return const Center(
              child: Text('Vui lòng đăng nhập để xem sách yêu thích.'),
            );
          }

          final repository = LibraryRepositoryImpl(LibraryRemoteDataSource());

          return FutureBuilder<List<BookEntity>>(
            future: GetFavoriteBooks(repository).call(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              final books = snapshot.data ?? [];
              if (books.isEmpty) {
                return const Center(child: Text("No favorite books yet."));
              }

              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return ListTile(
                    leading: Image.network(
                      book.coverImageUrl,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(book.title),
                    subtitle: Text(book.author),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
