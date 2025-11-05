import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel?> getUserByUid({String? uid});
  Future<void> updateUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UserRemoteDataSourceImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  DocumentReference _userDocRef(String uid) =>
      firestore.collection('users').doc(uid);

  @override
  Future<UserModel?> getUserByUid({String? uid}) async {
    final theUid = uid ?? auth.currentUser?.uid;
    if (theUid == null) return null;
    final doc = await _userDocRef(theUid).get();
    if (!doc.exists) {
      // Optionally create minimal doc from auth user
      final a = auth.currentUser;
      final fallback = {
        'name': a?.displayName ?? '',
        'email': a?.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _userDocRef(theUid).set(fallback, SetOptions(merge: true));
      final newDoc = await _userDocRef(theUid).get();
      return UserModel.fromFirestore(newDoc);
    }
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _userDocRef(
      user.id,
    ).set(user.toMapForUpdate(), SetOptions(merge: true));
  }
}
