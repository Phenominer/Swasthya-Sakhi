import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _typeColor(String type) {
    switch (type) {
      case "critical":
        return Colors.redAccent;
      case "info":
        return Colors.blueAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case "critical":
        return Icons.error_outline_rounded;
      case "info":
        return Icons.info_outline_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final alerts = app.alerts;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Alerts & Notifications",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];
            final unread = !alert["read"];
            final type = alert["type"];
            final msg = alert["msg"];
            final color = _typeColor(type);
            final id = alert["id"];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Dismissible(
                key: ValueKey(id),
                direction: DismissDirection.endToStart,

                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 28),
                ),

                onDismissed: (_) {
                  app.markAlertRead(id);
                },

                child: GestureDetector(
                  onTap: () {
                    app.markAlertRead(id);
                  },

                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(unread ? 0.12 : 0.06),
                          Colors.white.withOpacity(unread ? 0.05 : 0.03),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: unread
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.35),
                                blurRadius: 16,
                                spreadRadius: 1,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                      border: Border.all(
                        color: unread
                            ? color.withOpacity(0.5)
                            : Colors.white.withOpacity(0.1),
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ICON
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.withOpacity(0.15),
                          ),
                          child: Icon(_typeIcon(type), color: color, size: 24),
                        ),

                        const SizedBox(width: 14),

                        // MESSAGE CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.toUpperCase(),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                msg,
                                style: TextStyle(
                                  color: unread ? Colors.white : Colors.white70,
                                  fontSize: 15,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (unread)
                          const Padding(
                            padding: EdgeInsets.only(left: 10, top: 8),
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.orangeAccent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
