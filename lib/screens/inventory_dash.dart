import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/appstate.dart';
import 'update_inventory.dart';
import 'new_inventory_item.dart';

class InventoryDashboard extends StatefulWidget {
  const InventoryDashboard({super.key});

  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard> {
  String searchQuery = "";

  bool isExpiringSoon(String expiry) {
    try {
      final date = DateTime.parse(expiry);
      return date.difference(DateTime.now()).inDays < 60;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final items = app.role == "admin" ? app.globalInventory : app.myInventory;

    final filtered = items.where((item) {
      final q = searchQuery.toLowerCase();
      return item["name"].toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Inventory Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddInventoryItemScreen()),
          );

          if (newItem != null) {
            app.addInventoryItem(newItem, global: app.role == "admin");
          }
        },
        child: const Icon(Icons.add, size: 28),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchField(),

            const SizedBox(height: 20),

            Expanded(
              child: filtered.isEmpty
                  ? _emptyInventory()
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _inventoryCard(filtered[index], app),
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
          hintText: "Search medicines...",
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _emptyInventory() {
    return const Center(
      child: Text(
        "Inventory Empty",
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }

  Widget _inventoryCard(Map<String, dynamic> item, AppState app) {
    final stock = item["stock"];
    final expSoon = isExpiringSoon(item["expiry"]);

    Color statusColor;
    if (stock < 20 || expSoon) {
      statusColor = Colors.redAccent;
    } else if (stock < 50) {
      statusColor = Colors.amberAccent;
    } else {
      statusColor = Colors.greenAccent;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InventoryUpdateScreen(itemId: item["id"]),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(40, 255, 255, 255),
              Color.fromARGB(20, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.2),
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.08),
              child: const Icon(
                Icons.medication_rounded,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    "Stock: $stock",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    "Expiry: ${item["expiry"]}",
                    style: TextStyle(
                      color: expSoon ? Colors.redAccent : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

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
