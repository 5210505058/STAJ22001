import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'spin_wheel_page.dart';
import 'rank_page.dart';
import 'profile_page.dart';
import 'qr_code_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Map<String, dynamic> currentUser;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentUser,
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

  void _addPointsToRank(int points) {
    setState(() {
      totalPoints += points;
    });
  }

  void _updateUserProfile(Map<String, dynamic> updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) {
        bool isDark = widget.isDarkMode;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
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
                          setStateDialog(() {
                            isDark = val;
                          });
                          widget.onThemeChanged(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text("Çıkış Yap"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Kapat"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Rank görseli
  Widget _buildRankImage() {
    String rankImage;
    if (totalPoints < 50) {
      rankImage = 'assets/ranks/bronze.png';
    } else if (totalPoints < 100) {
      rankImage = 'assets/ranks/silver.png';
    } else if (totalPoints < 200) {
      rankImage = 'assets/ranks/gold.png';
    } else if (totalPoints < 400) {
      rankImage = 'assets/ranks/platinum.png';
    } else {
      rankImage = 'assets/ranks/diamond.png';
    }

    return Image.asset(
      rankImage,
      height: 60,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.emoji_events, size: 60, color: Colors.amber);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      RankPage(totalPoints: totalPoints),
      ProfilePage(
        currentUser: _currentUser,
        onProfileUpdated: _updateUserProfile,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Çarkım Var"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo ve Rank görseli birlikte ortalanmış
            Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.flutter_dash, size: 100, color: Colors.blue);
                  },
                ),
                const SizedBox(height: 10),
                _buildRankImage(),
              ],
            ),
            const SizedBox(height: 10),

            // Kullanıcı adı
            Text(
              _currentUser['name'] ?? 'Kullanıcı',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            // Uygulama sloganı ve telefon
            Text(
              "Çarkım Var - Eğlenceli ve Kazançlı Uygulama!",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "Tel: 444 444 444",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Çark ve QR Kod butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpinWheelPage(
                          onSpinCompleted: (earnedPoints) {
                            _addPointsToRank(earnedPoints);
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text("Çarkı Çevir"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCodePage(
                          userName: _currentUser['name'],
                          level: totalPoints < 50
                              ? "Bronz"
                              : totalPoints < 100
                              ? "Silver"
                              : totalPoints < 200
                              ? "Gold"
                              : totalPoints < 400
                              ? "Platinum"
                              : "Elmas",
                          discount: totalPoints < 50
                              ? 10
                              : totalPoints < 100
                              ? 15
                              : totalPoints < 200
                              ? 20
                              : totalPoints < 400
                              ? 25
                              : 30,
                        ),
                      ),
                    );
                  },
                  child: const Text("QR Kodum"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Alt sekmeler
            SizedBox(
              height: 500,
              child: pages[_currentIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rank"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
