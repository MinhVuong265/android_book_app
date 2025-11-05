import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String? email;
  Timestamp? birthDate;
  String? gender;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
    final data = doc.data()!;

    setState(() {
      nameController.text = data['name'] ?? '';
      phoneController.text = data['phoneNumber'] ?? '';
      addressController.text = data['address'] ?? '';
      email = data['email'];
      birthDate = data['birthDate'];
      gender = data['gender'];
    });
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      'name': nameController.text.trim(),
      'phoneNumber': phoneController.text.trim(),
      'address': addressController.text.trim(),
    });

    if (mounted) Navigator.pop(context);
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Not set";
    final date = timestamp.toDate();
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            // Read-only info
            _buildReadOnly("Email", email ?? "Not set"),
            _buildReadOnly("Gender", gender ?? "Not set"),
            _buildReadOnly("Birth Date", formatDate(birthDate)),

            const SizedBox(height: 16),

            // Editable fields
            _buildEditable("Full Name", nameController),
            _buildEditable("Phone Number", phoneController),
            _buildEditable("Address", addressController),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Floating Save Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 200,
        height: 55,
        child: ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: StadiumBorder(),
            elevation: 6,
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildEditable(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildReadOnly(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
