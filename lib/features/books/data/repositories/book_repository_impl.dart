
import 'package:book_app/features/books/data/datasources/firebase_book_datasource.dart';
import 'package:book_app/features/books/data/models/book_model.dart';
import 'package:book_app/features/books/domain/entities/book_entity.dart';
import 'package:book_app/features/books/domain/repositories/book_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class BookRepositoryImpl implements BookRepository{
  final FirebaseBookDatasource _firebaseBookDatasource;

  BookRepositoryImpl(this._firebaseBookDatasource);

  @override
  Future<BookEntity> addBook(BookEntity book) async {
    final bookModel = BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      category: book.category,
      description: book.description,
      coverImageUrl: book.coverImageUrl,
      content: book.content,
      publisher: book.publisher,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
    final BookEntity newBook = await _firebaseBookDatasource.addBook(bookModel);

    return newBook;
  }

  @override
  Future<void> deleteBook(String id) async {
    await _firebaseBookDatasource.deleteBook(id);
  }

  @override
  Future<BookEntity> getBookById(String id) async {
    final BookModel book = await _firebaseBookDatasource.getBookById(id);
    return book;
  }

  @override
  Future<List<BookEntity>> getBooks() async {
    final List<BookModel> bookModels = await _firebaseBookDatasource.getBooks();
    final List<BookEntity> books = bookModels.map((model) => BookEntity(
      id: model.id,
      title: model.title,
      author: model.author,
      category: model.category,
      description: model.description,
      coverImageUrl: model.coverImageUrl,
      content: model.content,
      publisher: model.publisher,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    )).toList();
    return books;
  }

  @override
  Future<BookEntity> updateBook(BookEntity book) async{
    final BookModel bookModel = BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      category: book.category,
      description: book.description,
      coverImageUrl: book.coverImageUrl,
      content: book.content,
      publisher: book.publisher,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
    );
    final BookEntity updatedBook = await _firebaseBookDatasource.updateBook(bookModel);
    return updatedBook;
  }

}