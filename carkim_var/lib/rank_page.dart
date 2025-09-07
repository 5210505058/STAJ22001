import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RankPage extends StatelessWidget {
  final int totalPoints;

  const RankPage({super.key, required this.totalPoints});

  // Rank aralıkları ve görselleri
  List<Map<String, dynamic>> get ranks => [
    {"name": "Bronz", "min": 0, "max": 50, "color": Colors.brown, "image": "assets/ranks/bronze.png"},
    {"name": "Silver", "min": 50, "max": 100, "color": Colors.grey, "image": "assets/ranks/silver.png"},
    {"name": "Gold", "min": 100, "max": 200, "color": Colors.amber, "image": "assets/ranks/gold.png"},
    {"name": "Platinum", "min": 200, "max": 400, "color": Colors.blue, "image": "assets/ranks/platinum.png"},
    {"name": "Elmas", "min": 400, "max": 1000, "color": Colors.purple, "image": "assets/ranks/diamond.png"},
  ];

  Map<String, dynamic> get currentRank {
    for (var rank in ranks) {
      if (totalPoints >= rank['min'] && totalPoints < rank['max']) {
        return rank;
      }
    }
    return ranks.last;
  }

  double get progressPercent {
    final rank = currentRank;
    return (totalPoints - rank['min']) / (rank['max'] - rank['min']);
  }

  int get nextThreshold => currentRank['max'];

  @override
  Widget build(BuildContext context) {
    final rank = currentRank;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Mevcut rank yazısı
          Text(
            "Mevcut Rank: ${rank['name']}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // Rank görseli
          Image.asset(
            rank['image'],
            height: 120,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 20),

          // Progress bar
          LinearPercentIndicator(
            lineHeight: 25.0,
            percent: progressPercent.clamp(0.0, 1.0),
            center: Text("$totalPoints/${nextThreshold}"),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: rank['color'],
            backgroundColor: Colors.grey[300]!,
          ),
        ],
      ),
    );
  }
}
