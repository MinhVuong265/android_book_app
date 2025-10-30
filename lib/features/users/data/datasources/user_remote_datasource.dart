import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

class UserRemoteDataSource {
	final FirebaseFirestore firestore;
	UserRemoteDataSource({required this.firestore});

	Future<List<UserEntity>> fetchUsers() async {
		final querySnapshot = await firestore.collection('users').get();
		return querySnapshot.docs.map((doc) {
			final data = doc.data();
			final id = doc.id;
			final name = (data['name'] ?? '') as String;
			final email = (data['email'] ?? '') as String;
			DateTime? createdAt;
			final rawCreated = data['createdAt'];
			if (rawCreated is Timestamp) {
				createdAt = rawCreated.toDate();
			} else if (rawCreated is String) {
				try {
					createdAt = DateTime.parse(rawCreated);
				} catch (_) {}
			}
			return UserEntity(id: id, name: name, email: email, createdAt: createdAt);
		}).toList();
	}

		/// Fetch single user by id
		Future<UserEntity?> fetchUserById(String id) async {
			final doc = await firestore.collection('users').doc(id).get();
			if (!doc.exists) return null;
			final data = doc.data() ?? {};
			final name = (data['name'] ?? '') as String;
			final email = (data['email'] ?? '') as String;
			DateTime? createdAt;
			final rawCreated = data['createdAt'];
			if (rawCreated is Timestamp) {
				createdAt = rawCreated.toDate();
			} else if (rawCreated is String) {
				try {
					createdAt = DateTime.parse(rawCreated);
				} catch (_) {}
			}
			return UserEntity(id: doc.id, name: name, email: email, createdAt: createdAt);
		}

		/// Search users by query (name or email). Implementation fetches all and filters locally.
		Future<List<UserEntity>> searchUsers(String query) async {
			final q = query.trim().toLowerCase();
			if (q.isEmpty) return await fetchUsers();
			final all = await fetchUsers();
			return all.where((u) {
				final name = u.name.toLowerCase();
				final email = u.email.toLowerCase();
				return name.contains(q) || email.contains(q);
			}).toList();
		}

	Future<UserEntity> createUser(UserEntity user) async {
		final data = {
			'name': user.name,
			'email': user.email,
			'createdAt': user.createdAt != null ? Timestamp.fromDate(user.createdAt!) : FieldValue.serverTimestamp(),
		};
		final docRef = await firestore.collection('users').add(data);
		final newDoc = await docRef.get();
		final createdData = newDoc.data() ?? {};
		final id = newDoc.id;
		final name = (createdData['name'] ?? '') as String;
		final email = (createdData['email'] ?? '') as String;
		DateTime? createdAt;
		final rawCreated = createdData['createdAt'];
		if (rawCreated is Timestamp) {
			createdAt = rawCreated.toDate();
		} else if (rawCreated is String) {
			try {
				createdAt = DateTime.parse(rawCreated);
			} catch (_) {}
		}
		return UserEntity(id: id, name: name, email: email, createdAt: createdAt);
	}

	Future<UserEntity> updateUser(UserEntity user) async {
		final Map<String, Object?> data = {
			'name': user.name,
			'email': user.email,
			if (user.createdAt != null) 'createdAt': Timestamp.fromDate(user.createdAt!),
		};
		await firestore.collection('users').doc(user.id).update(data);
		return user;
	}

	Future<void> deleteUser(String id) async {
		await firestore.collection('users').doc(id).delete();
	}
}

