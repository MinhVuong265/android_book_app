import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import 'package:book_app/features/books/domain/entities/book_entity.dart';

class LibraryRemoteDataSource {
  final firestore = FirebaseFirestore.instance;

  Future<List<BookModel>> getFavoriteBooks(String userId) async {
    final snapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .get();

    return snapshot.docs.map((doc) {
      final bookData = doc.data();
      return BookModel.fromFirestore(bookData, doc.id);
    }).toList();
  }

  Future<List<BookModel>> getReadingHistory(String userId) async {
    final snapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("reading_history")
        .orderBy("lastRead", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final bookData = doc.data();
      return BookModel.fromFirestore(bookData, doc.id);
    }).toList();
  }

  Future<void> addToReadingHistory(String userId, BookEntity book) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("reading_history")
        .doc(book.id)
        .set({
          'id': book.id,
          'title': book.title,
          'author': book.author,
          'coverImageUrl': book.coverImageUrl,
          'lastRead': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  /// Thêm sách vào favorites (collection users/{userId}/favorites)
  Future<void> addToFavorites(String userId, BookEntity book) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(book.id)
        .set({
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'coverImageUrl': book.coverImageUrl,
      'addedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Xóa sách khỏi favorites
  Future<void> removeFromFavorites(String userId, String bookId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(bookId)
        .delete();
  }

  /// Kiểm tra xem sách đã nằm trong favorites chưa
  Future<bool> isFavorite(String userId, String bookId) async {
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(bookId)
        .get();
    return doc.exists;
  }
}
