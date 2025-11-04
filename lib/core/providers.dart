import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:book_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:book_app/features/users/data/datasources/user_remote_datasource.dart';

/// Provides a single [FirebaseFirestore] instance from the default Firebase
/// initialization.
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provides a [CategoryRemoteDataSource] that depends on [FirebaseFirestore].
// final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) {
//   final firestore = ref.read(firebaseFirestoreProvider);
//   return CategoryRemoteDataSource(firestore: firestore);
// });

/// Provides a [UserRemoteDataSource] that depends on [FirebaseFirestore].
final userRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return UserRemoteDataSource(firestore: firestore);
});
