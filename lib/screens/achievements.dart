import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final achievements = app.achievements; // NOW FROM APP STATE

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Achievements",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: achievements.isEmpty
            ? const Center(
                child: Text(
                  "No achievements unlocked yet!",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final ach = achievements[index];
                  final earned = ach["earned"] == true;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _achievementTile(
                      ach["title"] as String,
                      ach["icon"] as IconData,
                      earned,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _achievementTile(String title, IconData icon, bool earned) {
    final glow = earned ? Colors.blueAccent : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            earned
                ? Colors.blueAccent.withOpacity(0.25)
                : Colors.white.withOpacity(0.05),
            earned
                ? Colors.blueAccent.withOpacity(0.12)
                : Colors.white.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: earned ? Colors.blueAccent : Colors.white24,
          width: earned ? 1.6 : 1,
        ),
        boxShadow: earned
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glow.withOpacity(0.15),
            ),
            child: Icon(icon, size: 28, color: glow),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: earned ? Colors.white : Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Icon(
            earned ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            color: earned ? Colors.greenAccent : Colors.white38,
            size: 24,
          ),
        ],
      ),
    );
  }
}
