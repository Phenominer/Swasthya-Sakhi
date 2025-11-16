import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/appstate.dart';
import 'pateints.dart';

class WorkerDetailsScreen extends StatelessWidget {
  final String workerId; // FIXED: now takes ID only

  const WorkerDetailsScreen({super.key, required this.workerId});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // GET WORKER FROM APP STATE
    final worker = app.findWorkerById(workerId);
    if (worker == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: const Center(
          child: Text(
            "Worker not found",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          worker["name"] ?? "Worker",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker["name"] ?? "Unknown",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          worker["role"] ?? "Not assigned",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // INFO SECTION
            _infoRow("Phone", worker["phone"] ?? "N/A"),
            _infoRow("Area", worker["area"] ?? "N/A"),
            _infoRow("Organisation", worker["organisation"] ?? "N/A"),

            const SizedBox(height: 25),

            // STATS
            Row(
              children: [
                _statBox("Patients", worker["patients"]?.toString() ?? "0"),
                const SizedBox(width: 12),
                _statBox("Points", worker["points"]?.toString() ?? "0"),
                const SizedBox(width: 12),
                _statBox("Streak", worker["streak"]?.toString() ?? "0"),
              ],
            ),

            const SizedBox(height: 25),

            // VIEW ASSIGNED PATIENTS BUTTON
            InkWell(
              onTap: () {
                // ADMIN → sees all patients under this worker
                // WORKER → sees only own myPatients
                final patients = app.role == "admin"
                    ? app.allPatients
                          .where((p) => (p["workerId"] ?? "") == workerId)
                          .toList()
                    : app.myPatients;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PatientsListScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E3A8A).withOpacity(0.9),
                      const Color(0xFF3B82F6).withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "View Assigned Patients",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // INFO ROW
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // STAT BOX
  Widget _statBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
