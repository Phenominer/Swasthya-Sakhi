import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    final sorted = [...app.leaderboard]
      ..sort((a, b) => b["points"].compareTo(a["points"]));

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Leaderboard", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: sorted.isEmpty
            ? const Center(
                child: Text(
                  "No leaderboard data available.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final user = sorted[index];
                  final rank = index + 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _leaderboardTile(
                      name: user["name"],
                      points: user["points"],
                      rank: rank,
                      highlight: rank <= 3,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _leaderboardTile({
    required String name,
    required int points,
    required int rank,
    required bool highlight,
  }) {
    final color = highlight ? Colors.blueAccent : Colors.white54;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            highlight
                ? Colors.blueAccent.withOpacity(0.25)
                : Colors.white.withOpacity(0.06),
            highlight
                ? Colors.blueAccent.withOpacity(0.12)
                : Colors.white.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: highlight ? Colors.blueAccent : Colors.white24,
          width: highlight ? 1.6 : 1,
        ),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$points points",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),

          if (rank == 1)
            const Icon(
              Icons.emoji_events_rounded,
              color: Colors.yellowAccent,
              size: 28,
            ),
          if (rank == 2)
            const Icon(
              Icons.emoji_events_rounded,
              color: Colors.grey,
              size: 26,
            ),
          if (rank == 3)
            const Icon(
              Icons.emoji_events_rounded,
              color: Colors.brown,
              size: 26,
            ),
        ],
      ),
    );
  }
}
