import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _accent = Color(0xFFFFB020); // amber
const _textSoftOpacity = 0.78;

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
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.currentUser['name'] ?? "");
    _emailController =
        TextEditingController(text: widget.currentUser['email'] ?? "");
    _phoneController =
        TextEditingController(text: widget.currentUser['phone'] ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedUser = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
    };
    widget.onProfileUpdated(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Profil güncellendi"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _accent.withOpacity(0.95),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          children: [
            // Profil resmi + isim
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    _accent.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: _accent.withOpacity(0.2), width: 1),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: _accent.withOpacity(0.25),
                    child: const Icon(Icons.person,
                        size: 50, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nameController.text.isEmpty
                        ? "Kullanıcı"
                        : _nameController.text,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bilgi alanları
            _buildField("Ad Soyad", _nameController, theme),
            const SizedBox(height: 14),
            _buildField("E-posta", _emailController, theme),
            const SizedBox(height: 14),
            _buildField("Telefon", _phoneController, theme),

            const SizedBox(height: 24),

            // Kaydet butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  backgroundColor: _accent,
                  foregroundColor: Colors.black,
                ),
                onPressed: _saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, ThemeData theme) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black.withOpacity(_textSoftOpacity),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _accent.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _accent, width: 1.8),
        ),
      ),
      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
    );
  }
}
