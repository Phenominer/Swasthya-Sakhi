import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({super.key, required this.patientId});

  Color _statusColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "critical":
        return Colors.redAccent;
      case "attention":
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  IconData _statusIcon(String? status) {
    switch ((status ?? "").toLowerCase()) {
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

    // Fetch patient from global state
    final patient = app.findPatientById(patientId);

    if (patient == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Patient Not Found",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text(
            "The requested patient does not exist.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    final statusColor = _statusColor(patient["status"]);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          patient["name"] ?? "Patient",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.22),
                      statusColor.withOpacity(0.08),
                    ],
                  ),
                  border: Border.all(color: statusColor.withOpacity(0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: statusColor.withOpacity(0.2),
                      child: Icon(
                        _statusIcon(patient["status"]),
                        color: statusColor,
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient["name"] ?? "Unnamed",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${patient["status"] ?? "Unknown"}",
                            style: TextStyle(color: statusColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _detailTile(
                "Age",
                patient["age"]?.toString() ?? "N/A",
                Icons.calendar_today_rounded,
              ),
              _detailTile(
                "Gender",
                patient["gender"] ?? "N/A",
                Icons.person_rounded,
              ),
              _detailTile(
                "Address",
                patient["address"] ?? "N/A",
                Icons.location_on_rounded,
              ),
              _detailTile(
                "Phone",
                patient["phone"] ?? "N/A",
                Icons.phone_rounded,
              ),
              _detailTile(
                "Last Visit",
                patient["lastVisit"] ?? "N/A",
                Icons.history_rounded,
              ),
              _detailTile(
                "Next Visit",
                patient["nextVisit"] ?? "N/A",
                Icons.event_available,
              ),

              const SizedBox(height: 20),

              if (patient["history"] != null &&
                  patient["history"] is List &&
                  patient["history"].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Medical History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...List.generate(patient["history"].length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          patient["history"][index],
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    }),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
