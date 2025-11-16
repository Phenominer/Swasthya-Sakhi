import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/appstate.dart';
import 'pateints_details.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  String search = "";

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "critical":
        return Colors.redAccent;
      case "attention":
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "critical":
        return Icons.warning_amber_rounded;
      case "attention":
        return Icons.info_outline_rounded;
      default:
        return Icons.health_and_safety_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    final all = app.role == "admin" ? app.allPatients : app.myPatients;

    final filtered = all.where((p) {
      final q = search.toLowerCase();
      return p["name"].toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Patients List",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SEARCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => setState(() => search = value),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.blueAccent),
                  hintText: "Search patients...",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        "No patients found",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _patientCard(p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientCard(Map<String, dynamic> p) {
    final color = _statusColor(p["status"] ?? "stable");

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PatientDetailsScreen(patientId: p["id"]),
          ),
        );
      },

      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.18), color.withOpacity(0.08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.18),
              child: Icon(
                _statusIcon(p["status"] ?? ""),
                color: color,
                size: 26,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Age: ${p["age"]}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Address: ${p["address"]}",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
