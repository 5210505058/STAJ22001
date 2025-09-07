import 'package:flutter/material.dart';

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

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final user = widget.users[email];
    if (user != null && user['password'] == password) {
      widget.onLogin(user);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hatalı e-mail veya şifre")),
      );
    }
  }

  void _registerDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailRegController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordRegController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text("Kayıt Ol"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: "İsim")),
                  TextField(controller: emailRegController, decoration: const InputDecoration(labelText: "E-mail")),
                  TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Telefon")),
                  TextField(controller: passwordRegController, decoration: const InputDecoration(labelText: "Şifre"), obscureText: true),
                ],
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
                      'name': nameController.text,
                      'email': email,
                      'phone': phoneController.text,
                      'password': passwordRegController.text,
                    };
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kayıt başarılı!")),
                    );
                  },
                  child: const Text("Kayıt Ol"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.flutter_dash, size: 100, color: Colors.blue);
                },
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "E-mail"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Şifre"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text("Giriş Yap")),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _registerDialog, child: const Text("Kayıt Ol")),
            ],
          ),
        ),
      ),
    );
  }
}
