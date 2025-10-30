import 'package:book_app/features/books/data/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/book_entity.dart';

class FirebaseBookDatasource {
  final FirebaseFirestore _firestore;

  FirebaseBookDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String _collectionPath = 'books';

  Future<List<BookModel>> getBooks() async {
    final querySnapshot = await _firestore.collection(_collectionPath).orderBy('createAt', descending: true).get();
    return querySnapshot.docs
        .map((doc) => BookModel.fromMap(doc))
        .toList();
  }

  Future<BookModel> getBookById(String id) async {
    final docSnapshot =
        await _firestore.collection(_collectionPath).doc(id).get();
    if (!docSnapshot.exists) {
      throw Exception('Book not found');
    }
    return BookModel.fromMap(docSnapshot!);
  }

  Future<BookModel> addBook(BookModel book) async {
    await _firestore
        .collection(_collectionPath)
        .doc(book.id)
        .set(book.toMap());
    return book;
  }

  Future<BookModel> updateBook(BookModel book) async {
    await _firestore
        .collection(_collectionPath)
        .doc(book.id)
        .update(book.toMap());
    return book;
  }

  Future<void> deleteBook(String id) async {
    await _firestore.collection(_collectionPath).doc(id).delete();
  }

}