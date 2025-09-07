import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? _currentUser;
  Map<String, Map<String, dynamic>> _users = {}; // global users
  bool _isDarkMode = false;

  void _toggleDarkMode(bool val) {
    setState(() => _isDarkMode = val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Çarkım Var',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: _currentUser == null
          ? LoginPage(
        users: _users,
        onLogin: (user) {
          setState(() => _currentUser = user);
        },
      )
          : HomePage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleDarkMode,
        currentUser: _currentUser!,
        onLogout: () {
          // Çıkış: kullanıcıyı sıfırla, otomatik olarak LoginPage döner
          setState(() => _currentUser = null);
        },
      ),
    );
  }
}
