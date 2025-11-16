import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swasth_sakhi/screens/pateints.dart';

import '../state/appstate.dart';

import 'add_worker.dart';
import 'worker_list.dart';
import 'inventory_dash.dart';
import 'alerts_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // Compute low stock items (demo rule: stock < 50)
    final lowStockCount = app.globalInventory
        .where((item) => (item["stock"] ?? 0) < 50)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* --------------------------- HEADER ------------------------------ */
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Swasth Sakhi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Welcome, ${app.userName}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  // Online badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOnline ? Icons.wifi : Icons.wifi_off,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOnline ? "Online" : "Offline",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /* --------------------------- OVERVIEW ------------------------------ */
            _sectionTitle("Overview"),

            Row(
              children: [
                Expanded(
                  child: _AdminStatCard(
                    label: "Workers",
                    value: app.allWorkers.length.toString(),
                    icon: Icons.group,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AdminStatCard(
                    label: "Patients",
                    value: app.allPatients.length.toString(),
                    icon: Icons.people_alt,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _AdminStatCard(
                    label: "Alerts",
                    value: app.unreadAlerts.length.toString(),
                    icon: Icons.notification_important_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AdminStatCard(
                    label: "Low Stock",
                    value: lowStockCount.toString(),
                    icon: Icons.inventory_2_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /* --------------------------- ACTIONS ------------------------------ */
            _sectionTitle("Admin Actions"),

            _AdminActionCard(
              title: "Add Worker",
              icon: Icons.person_add_alt_1_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddWorkerForm()),
                );
              },
            ),
            const SizedBox(height: 12),

            _AdminActionCard(
              title: "View Workers",
              icon: Icons.view_list_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkerListScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            _AdminActionCard(
              title: "Inventory Dashboard",
              icon: Icons.inventory_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InventoryDashboard()),
                );
              },
            ),
            const SizedBox(height: 12),

            _AdminActionCard(
              title: "Alerts & Reports",
              icon: Icons.warning_amber_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AlertsScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
            _AdminActionCard(
              title: "View Patients",
              icon: Icons.warning_amber_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientsListScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------
   REUSABLE WIDGETS
--------------------------------------------------------------------- */

class _AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _AdminStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 26),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _AdminActionCard({required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.blueAccent.withOpacity(0.2),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
              Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.blueAccent),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.6),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
