import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:book_app/core/routing/app_routes.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  String getInitial(String? name) {
    if (name == null || name.isEmpty) return "?";
    return name[0].toUpperCase();
  }

  // ✅ Format Date without intl
  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Not set";
    final date = timestamp.toDate();
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Try to pop; if there's no back stack (returns false), go to Home
            final didPop = await Navigator.of(context).maybePop();
            if (!didPop) {
              // use go_router to navigate to home
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 26),
            onPressed: () => context.push(AppRoutes.editProfile),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['name'];
          final email = data['email'];
          final phone = data['phoneNumber'];
          final gender = data['gender'];
          final address = data['address'];
          final birthDate = data['birthDate']; // ✅ Firestore Timestamp

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    getInitial(name),
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(email, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 24),

                buildInfoCard(Icons.phone, "Phone", phone),
                buildInfoCard(Icons.person, "Gender", gender),
                buildInfoCard(Icons.location_on, "Address", address),

                // ✅ NEW: Birth date card
                buildInfoCard(
                  Icons.calendar_today,
                  "Birth Date",
                  formatDate(birthDate),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 26),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
