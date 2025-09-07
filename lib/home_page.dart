import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'spin_wheel_page.dart';
import 'rank_page.dart';
import 'profile_page.dart';
import 'qr_code_page.dart';

// THEME: Amber
const _accent = Color(0xFFFFB020); // amber
const _textSoftOpacity = 0.78;

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Map<String, dynamic> currentUser;
  final VoidCallback onLogout;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentUser,
    required this.onLogout,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int totalPoints = 0;
  late Map<String, dynamic> _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.currentUser;
  }

  void _addPointsToRank(int points) => setState(() => totalPoints += points);
  void _updateUserProfile(Map<String, dynamic> updatedUser) => setState(() => _currentUser = updatedUser);

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) {
        bool isDark = widget.isDarkMode;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Ayarlar"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Koyu Tema", style: TextStyle(fontSize: 16)),
                      Switch(
                        value: isDark,
                        onChanged: (val) {
                          setStateDialog(() => isDark = val);
                          widget.onThemeChanged(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onLogout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Çıkış Yap"),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat")),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      RankPage(totalPoints: totalPoints),
      ProfilePage(currentUser: _currentUser, onProfileUpdated: _updateUserProfile),
    ];

    return Scaffold(
      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Çarkım Var",
          style: TextStyle(
            color: _accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: _accent),
            onPressed: _openSettings,
          ),
        ],
      ),

      // BODY
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            children: [
              // Üst bölüm (logo + isim) — hafif beyaz→amber degrade
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      _accent.withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(_accent, BlendMode.srcIn),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.flutter_dash, size: 56, color: _accent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Merhaba ${_currentUser['name'] ?? 'Kullanıcı'}!",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Çarkım Var - Eğlenceli ve Kazançlı Uygulama!",
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: Colors.black.withOpacity(_textSoftOpacity),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Puan/Seviye kartı — beyaz→amber çok hafif degrade
              _StatCard(
                title: "Toplam Puan",
                value: "$totalPoints",
                subtitle: _levelText(totalPoints),
                accent: _levelColor(_levelText(totalPoints)),
                titleColor: Colors.black.withOpacity(_textSoftOpacity),
                valueColor: Colors.black,
              ),

              const SizedBox(height: 16),

              // Aksiyon butonları bölümü — beyaz→amber çok hafif degrade
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
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
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.casino),
                        label: const Text("Çarkı Çevir"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: _accent,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpinWheelPage(onSpinCompleted: (p) => _addPointsToRank(p)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code),
                        label: const Text("QR Kodum"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: _accent, // amber
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QRCodePage(
                                userName: _currentUser['name'],
                                level: _levelText(totalPoints),
                                discount: _discountFor(totalPoints),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Alt sekmeler
              SizedBox(height: 520, child: pages[_currentIndex]),
            ],
          ),
        ),
      ),

      // NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: Colors.black54,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rank"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  String _levelText(int pts) {
    if (pts < 50) return "Bronz";
    if (pts < 100) return "Silver";
    if (pts < 200) return "Gold";
    if (pts < 400) return "Platinum";
    return "Elmas";
  }

  Color _levelColor(String lvl) {
    switch (lvl.toLowerCase()) {
      case "bronz":
      case "bronze":
        return const Color(0xFFCD7F32);
      case "silver":
        return const Color(0xFFC0C0C0);
      case "gold":
        return const Color(0xFFFFD700);
      case "platinum":
        return const Color(0xFFE5E4E2);
      case "elmas":
      case "diamond":
        return const Color(0xFF5AC8FA);
      default:
        return _accent;
    }
  }

  int _discountFor(int pts) {
    if (pts < 50) return 10;
    if (pts < 100) return 15;
    if (pts < 200) return 20;
    if (pts < 400) return 25;
    return 30;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color accent;
  final Color titleColor;
  final Color valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.titleColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: accent.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              accent.withOpacity(0.08), // amberden çok hafif yansıma
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [accent, accent.withOpacity(0.55)]),
              ),
              child: const Icon(Icons.workspace_premium, color: Colors.black),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 13.5, color: titleColor)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        value,
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: valueColor),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accent.withOpacity(0.35)),
                        ),
                        child: Text(
                          subtitle,
                          style: GoogleFonts.poppins(fontSize: 12.5, color: accent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
