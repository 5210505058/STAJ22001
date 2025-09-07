import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Amber temasıyla uyumlu Rank sayfası
const _accent = Color(0xFFFFB020); // amber
const _textSoftOpacity = 0.78;

class RankPage extends StatelessWidget {
  final int totalPoints;

  const RankPage({super.key, required this.totalPoints});

  // Rank aralıkları ve görselleri
  List<Map<String, dynamic>> get ranks => [
    {
      "name": "Bronz",
      "min": 0,
      "max": 50,
      "color": const Color(0xFFCD7F32),
      "image": "assets/ranks/bronze.png"
    },
    {
      "name": "Silver",
      "min": 50,
      "max": 100,
      "color": const Color(0xFFC0C0C0),
      "image": "assets/ranks/silver.png"
    },
    {
      "name": "Gold",
      "min": 100,
      "max": 200,
      "color": const Color(0xFFFFD700),
      "image": "assets/ranks/gold.png"
    },
    {
      "name": "Platinum",
      "min": 200,
      "max": 400,
      "color": const Color(0xFFE5E4E2),
      "image": "assets/ranks/platinum.png"
    },
    {
      "name": "Elmas",
      "min": 400,
      "max": 1 << 30, // pratik "sonsuz"
      "color": const Color(0xFF5AC8FA),
      "image": "assets/ranks/diamond.png"
    },
  ];

  Map<String, dynamic> get currentRank {
    for (var rank in ranks) {
      if (totalPoints >= rank['min'] && totalPoints < rank['max']) {
        return rank;
      }
    }
    return ranks.last;
  }

  bool get isMaxRank => identical(currentRank, ranks.last);

  double get progressPercent {
    final rank = currentRank;
    if (isMaxRank) return 1.0; // en üst seviye
    final span = (rank['max'] as num) - (rank['min'] as num);
    return ((totalPoints - (rank['min'] as int)) / span).clamp(0.0, 1.0);
  }

  int? get nextThreshold => isMaxRank ? null : currentRank['max'] as int;

  @override
  Widget build(BuildContext context) {
    final rank = currentRank;
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          children: [
            // Üst bilgi kartı — beyaz→amber çok hafif gradient
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
                  // Rozet simgesi (mevcut rank renginde)
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (rank['color'] as Color),
                          (rank['color'] as Color).withOpacity(0.55)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (rank['color'] as Color).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.workspace_premium, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mevcut Rank: ${rank['name']}",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isMaxRank
                              ? "Maksimum seviyedesin. Tebrikler!"
                              : "Bir sonraki seviye için hedef: ${nextThreshold} puan",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color:
                            Colors.black.withOpacity(_textSoftOpacity),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rank görseli
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(color: _accent.withOpacity(0.18), width: 1),
              ),
              child: Column(
                children: [
                  Image.asset(
                    rank['image'],
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.emoji_events,
                      size: 120,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Toplam Puan: $totalPoints",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // İlerleme çubuğu — köşeleri oval, animasyonlu
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
                border: Border.all(color: _accent.withOpacity(0.18), width: 1),
              ),
              child: Column(
                children: [
                  LinearPercentIndicator(
                    lineHeight: 26.0,
                    animation: true,
                    animationDuration: 800,
                    percent: progressPercent,
                    center: Text(
                      isMaxRank
                          ? "Maks seviye"
                          : "$totalPoints/${nextThreshold}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    barRadius: const Radius.circular(16),
                    progressColor: rank['color'],
                    backgroundColor: Colors.grey[300]!,
                  ),
                  if (!isMaxRank) ...[
                    const SizedBox(height: 10),
                    Text(
                      "Sonraki seviye için kalan: ${(nextThreshold! - totalPoints).clamp(0, 1 << 30)} puan",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.black.withOpacity(_textSoftOpacity),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Seviye rehberi — küçük “chip”ler
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(color: _accent.withOpacity(0.18), width: 1),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ranks.map((r) {
                  final active = identical(r, rank);
                  return _RankChip(
                    label: r['name'] as String,
                    color: r['color'] as Color,
                    active: active,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool active;

  const _RankChip({
    required this.label,
    required this.color,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? color.withOpacity(0.6) : Colors.black12,
          width: active ? 1.6 : 1.0,
        ),
        boxShadow: active
            ? [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black.withOpacity(active ? 0.95 : 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
