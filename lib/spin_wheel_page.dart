import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';


// Aynı palet (HomePage ile tutarlı)
const _accent = Color(0xFFFFB020); // amber
const _textSoftOpacity = 0.78;

class SpinWheelPage extends StatefulWidget {
  final Function(int)? onSpinCompleted;

  const SpinWheelPage({super.key, this.onSpinCompleted});

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {
  late final StreamController<int> controller;
  final random = Random();

  // Çark dilimleri (puanlar)
  final items = <int>[10, 20, 30, 50];

  bool canSpin = true;
  DateTime? lastSpinTime;
  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>();
    _checkLastSpin();
    // Sayfa açılır açılmaz dönmemesi için başlangıçta selection yok
  }

  @override
  void dispose() {
    controller.close();
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLastSpin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSpinMillis = prefs.getInt("lastSpinTime");

    if (lastSpinMillis != null) {
      lastSpinTime = DateTime.fromMillisecondsSinceEpoch(lastSpinMillis);
      final diff = DateTime.now().difference(lastSpinTime!);
      if (diff.inSeconds < 24 * 3600) {
        setState(() {
          canSpin = false;
          remainingTime = Duration(seconds: 24 * 3600 - diff.inSeconds);
        });
        _startCountdown();
      }
    }
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        countdownTimer?.cancel();
        setState(() {
          canSpin = true;
        });
      }
    });
  }

  Future<void> spinWheel() async {
    if (!canSpin) return;

    final selected = random.nextInt(items.length);
    controller.add(selected); // index veriyoruz

    final earnedPoints = items[selected];

    // Dışarıya bilgi gönder
    if (widget.onSpinCompleted != null) {
      widget.onSpinCompleted!(earnedPoints);
    }

    // 24 saatlik kilidi başlat
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastSpinTime", DateTime.now().millisecondsSinceEpoch);

    setState(() {
      canSpin = false;
      lastSpinTime = DateTime.now();
      remainingTime = const Duration(hours: 24);
    });
    _startCountdown();

    // Kullanıcıya küçük bir bildirim
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$earnedPoints puan kazandın!"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _accent.withOpacity(0.95),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes % 60);
    final seconds = twoDigits(d.inSeconds % 60);
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar — beyaz zemin, amber başlık
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Çarkı Çevir",
          style: TextStyle(
            color: _accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      // Gövde — beyaz arka plan
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              children: [
                // Üst bilgi bloğu — beyaz→amber çok hafif gradient
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
                  child: Column(
                    children: [
                      Text(
                        "Şansını dene ve puan kazan!",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        canSpin
                            ? "Hazırsan çevir!"
                            : "Tekrar çevirmek için bekleme: ${_formatDuration(remainingTime)}",
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: canSpin
                              ? Colors.black.withOpacity(_textSoftOpacity)
                              : Colors.red.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Çark alanı — cam efekti gibi hafif gradient arka plan
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
                    border: Border.all(color: _accent.withOpacity(0.2), width: 1),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420, minHeight: 320),
                    child: AspectRatio(
                      aspectRatio: 1, // kare alan
                      child: FortuneWheel(
                        selected: controller.stream,
                        animateFirst: false, // sayfa açılır açılmaz dönmesin
                        indicators: const <FortuneIndicator>[
                          FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color: _accent,
                            ),
                          ),
                        ],
                        items: [
                          // Amber’la uyumlu dilim renkleri (açık/koyu dönüşümlü)
                          _buildItem(items[0], color: const Color(0xFFFFE9C7)), // açık amber
                          _buildItem(items[1], color: const Color(0xFFFFD28A)), // orta
                          _buildItem(items[2], color: const Color(0xFFFFE9C7)),
                          _buildItem(items[3], color: const Color(0xFFFFD28A)),
                        ],
                        // Dönüş animasyonu biraz “premium” hissettirsin
                        physics: CircularPanPhysics(
                          duration: const Duration(seconds: 4),
                          curve: Curves.easeOutQuart,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Buton — amber
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.casino),
                    label: Text(
                      canSpin ? "Çevir!" : "Bekleniyor...",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: _accent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: canSpin ? spinWheel : null,
                  ),
                ),

                const SizedBox(height: 6),

                // Ek bilgi (kırmızı sayaç zaten üst blokta da var)
                if (!canSpin)
                  Text(
                    "Günde 1 kez çevirebilirsin.",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: Colors.black.withOpacity(_textSoftOpacity),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FortuneItem oluşturucu — tek tip görsellikte
  FortuneItem _buildItem(int value, {required Color color}) {
    return FortuneItem(
      child: Text(
        "$value Puan",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black.withOpacity(0.85),
        ),
      ),
      style: FortuneItemStyle(
        color: color,
        borderColor: _accent.withOpacity(0.8),
        borderWidth: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}
