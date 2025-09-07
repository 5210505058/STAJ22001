import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _accent = Color(0xFFFFB020); // amber
const _textSoftOpacity = 0.78;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(email);
  }

  void _register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final pass  = passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tüm alanları doldur lütfen.")),
      );
      return;
    }
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Geçerli bir e-mail gir.")),
      );
      return;
    }
    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifre en az 6 karakter olmalı.")),
      );
      return;
    }

    // Burada gerçek kayıt (API/Firebase) işlemini yapabilirsin.
    // Başarılıysa önce bilgi ver, sonra geri dön.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Kayıt başarılı! Giriş sayfasına dönülüyor."),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _accent.withOpacity(0.95),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar — beyaz zemin, amber başlık
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Kayıt Ol",
          style: TextStyle(
            color: _accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  // Logo (amber filtreli)
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(_accent, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 92,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.flutter_dash, size: 84, color: _accent),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    "Yeni hesap oluştur",
                    style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Bilgilerini girerek hemen aramıza katıl.",
                    style: GoogleFonts.poppins(
                      fontSize: 13.5, color: Colors.black.withOpacity(_textSoftOpacity),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 18),

                  // Form kartı — beyaz→amber hafif gradient
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.white, _accent.withOpacity(0.06)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: _accent.withOpacity(0.2), width: 1),
                    ),
                    child: Column(
                      children: [
                        _field("İsim", nameController, Icons.person, textInputAction: TextInputAction.next),
                        const SizedBox(height: 10),
                        _field("E-mail", emailController, Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next),
                        const SizedBox(height: 10),
                        _field("Telefon", phoneController, Icons.phone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                              tooltip: _obscure ? "Göster" : "Gizle",
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black.withOpacity(_textSoftOpacity),
                            ),
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
                          onSubmitted: (_) => _register(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Kayıt ol butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text("Kayıt Ol"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: _accent,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _register,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType? keyboardType,
        TextInputAction? textInputAction,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14, color: Colors.black.withOpacity(_textSoftOpacity),
        ),
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
