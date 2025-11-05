import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/usecases/get_reading_history.dart';
import '../../data/datasources/library_remote_data_source.dart';
import '../../data/repositories/library_repository_impl.dart';

class ReadingHistoryPage extends StatelessWidget {
  const ReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reading History")),
      body: Builder(
        builder: (context) {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) {
            return const Center(
              child: Text('Vui lòng đăng nhập để xem lịch sử đọc.'),
            );
          }

          final repository = LibraryRepositoryImpl(LibraryRemoteDataSource());

          return FutureBuilder<List<BookEntity>>(
            future: GetReadingHistory(repository).call(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              final books = snapshot.data ?? [];
              if (books.isEmpty) {
                return const Center(
                  child: Text("You haven't read any books yet."),
                );
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
                    subtitle: Text(
                      "Read at: ${book.updatedAt.toString().split(' ').first}",
                    ),
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
