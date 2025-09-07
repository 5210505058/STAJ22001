import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> currentUser;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const ProfilePage({
    super.key,
    required this.currentUser,
    required this.onProfileUpdated,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  XFile? profileImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentUser['name']);
    emailController = TextEditingController(text: widget.currentUser['email']);
    phoneController = TextEditingController(text: widget.currentUser['phone']);
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  void _saveProfile() {
    final updatedUser = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };
    widget.onProfileUpdated(updatedUser);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil güncellendi!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: profileImage != null
                  ? FileImage(File(profileImage!.path))
                  : const AssetImage("assets/profile_placeholder.png") as ImageProvider,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "İsim"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "E-mail"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Telefon"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: const Text("Güncelle"),
          ),
        ],
      ),
    );
  }
}
