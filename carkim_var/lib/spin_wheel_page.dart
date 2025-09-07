
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpinWheelPage extends StatefulWidget {
  final Function(int)? onSpinCompleted;

  const SpinWheelPage({super.key, this.onSpinCompleted});

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {
  late final StreamController<int> controller;
  final random = Random();
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
    // Çark açıldığında dönmemesi için başlangıçta hiçbir seçim eklemiyoruz
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
    controller.add(selected);

    final earnedPoints = items[selected];

    if (widget.onSpinCompleted != null) {
      widget.onSpinCompleted!(earnedPoints);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastSpinTime", DateTime.now().millisecondsSinceEpoch);

    setState(() {
      canSpin = false;
      lastSpinTime = DateTime.now();
      remainingTime = const Duration(hours: 24);
    });

    _startCountdown();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Çarkı Çevir")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FortuneWheel(
              selected: controller.stream,
              animateFirst: false, // <<< BURAYI EKLEDİK: Sayfa açıldığında dönmesin
              items: [
                for (var it in items) FortuneItem(child: Text("$it Puan")),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: canSpin ? spinWheel : null,
            child: const Text("Çevir!"),
          ),
          const SizedBox(height: 20),
          if (!canSpin)
            Text(
              "Tekrar çevirmek için: ${_formatDuration(remainingTime)}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
