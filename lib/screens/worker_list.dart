import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/appstate.dart';
import 'worker_details.dart';

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // this is global worker list for admin
    final workers = app.allWorkers;

    final filteredWorkers = workers.where((w) {
      final q = searchQuery.toLowerCase();
      return (w["name"] ?? "").toLowerCase().contains(q) ||
          (w["role"] ?? "").toLowerCase().contains(q) ||
          (w["village"] ?? "").toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Workers List",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchField(),
            const SizedBox(height: 20),

            Expanded(
              child: filteredWorkers.isEmpty
                  ? const Center(
                      child: Text(
                        "No workers found",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredWorkers.length,
                      itemBuilder: (context, index) {
                        final worker = filteredWorkers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _workerCard(worker),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.blueAccent),
          hintText: "Search workers...",
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _workerCard(Map<String, dynamic> worker) {
    final active = worker["active"] == true;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerDetailsScreen(workerId: worker["id"]),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: active
                ? Colors.greenAccent.withOpacity(0.4)
                : Colors.grey.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: active
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              child: Icon(
                active ? Icons.person : Icons.person_off,
                color: active ? Colors.greenAccent : Colors.grey,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worker["name"] ?? "Unknown",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${worker["role"] ?? 'Worker'} • ${worker["village"] ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),

            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: active ? Colors.greenAccent : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
