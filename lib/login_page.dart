import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _accent = Color(0xFFFFB020); // amber
const _textSoftOpacity = 0.78;

class LoginPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onLogin;
  final Map<String, Map<String, dynamic>> users; // global kullanıcı map

  const LoginPage({
    super.key,
    required this.onLogin,
    required this.users,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final user = widget.users[email];
    if (user != null && user['password'] == password) {
      widget.onLogin(user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Hatalı e-mail veya şifre"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _registerDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailRegController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordRegController = TextEditingController();
    bool obscureReg = true;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [_accent, _accent.withOpacity(0.55)],
                          ),
                        ),
                        child: const Icon(Icons.person_add, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      const Text("Kayıt Ol"),
                    ],
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.white, _accent.withOpacity(0.06)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: _accent.withOpacity(0.2), width: 1),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _field("İsim", nameController, Icons.person),
                        const SizedBox(height: 10),
                        _field("E-mail", emailRegController, Icons.email,
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 10),
                        _field("Telefon", phoneController, Icons.phone,
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordRegController,
                          obscureText: obscureReg,
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setStateDialog(() => obscureReg = !obscureReg),
                              icon: Icon(obscureReg ? Icons.visibility : Icons.visibility_off),
                              tooltip: obscureReg ? "Göster" : "Gizle",
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
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final email = emailRegController.text.trim();
                        if (email.isEmpty || passwordRegController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("E-mail ve şifre boş olamaz")),
                          );
                          return;
                        }
                        widget.users[email] = {
                          'name': nameController.text.trim(),
                          'email': email,
                          'phone': phoneController.text.trim(),
                          'password': passwordRegController.text,
                        };
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Kayıt başarılı!"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: _accent.withOpacity(0.95),
                          ),
                        );
                      },
                      child: const Text("Kayıt Ol"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("İptal"),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _field(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType? keyboardType,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo (amber filtreli)
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(_accent, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.flutter_dash, size: 88, color: _accent),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Hoş geldin!",
                    style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Hesabınla giriş yap veya yeni hesap oluştur",
                    style: GoogleFonts.poppins(
                      fontSize: 13.5, color: Colors.black.withOpacity(_textSoftOpacity),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 18),

                  // Kart: Giriş Formu (beyaz→amber sehr hafif gradient)
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
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            prefixIcon: const Icon(Icons.email),
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
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _login(),
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
                        ),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.login),
                            label: const Text("Giriş Yap"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              backgroundColor: _accent,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: _login,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Kayıt ol butonu (dialog)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text("Kayıt Ol"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: _accent.withOpacity(0.7), width: 1.4),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _registerDialog,
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
}
