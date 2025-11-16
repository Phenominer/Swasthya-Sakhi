import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/appstate.dart';

class InventoryUpdateScreen extends StatefulWidget {
  final String itemId; // Only ID now

  const InventoryUpdateScreen({super.key, required this.itemId});

  @override
  State<InventoryUpdateScreen> createState() => _InventoryUpdateScreenState();
}

class _InventoryUpdateScreenState extends State<InventoryUpdateScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String updateType = "add"; // "add" or "remove"

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // pick worker or admin inventory
    final list = app.role == "admin" ? app.globalInventory : app.myInventory;

    final item = list.firstWhere(
      (m) => m["id"] == widget.itemId,
      orElse: () => {},
    );

    if (item.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: const Center(
          child: Text(
            "Item not found",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    final name = item["name"];
    final stock = item["stock"];
    final expiry = item["expiry"];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          "Update Inventory",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* ----------------------------------
               ITEM HEADER
            ----------------------------------- */
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Current Stock: $stock",
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              "Expiry: $expiry",
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 30),

            /* ----------------------------------
               UPDATE TYPE (ADD/REMOVE)
            ----------------------------------- */
            Row(
              children: [
                _updateTypeChip("add", Icons.add_circle, Colors.greenAccent),
                const SizedBox(width: 12),
                _updateTypeChip(
                  "remove",
                  Icons.remove_circle,
                  Colors.redAccent,
                ),
              ],
            ),

            const SizedBox(height: 25),

            /* ----------------------------------
               QUANTITY INPUT
            ----------------------------------- */
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Quantity",
                labelStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.blueAccent,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /* ----------------------------------
               OPTIONAL NOTE
            ----------------------------------- */
            TextField(
              controller: noteController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Notes (optional)",
                labelStyle: const TextStyle(color: Colors.white54),
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),

            const Spacer(),

            /* ----------------------------------
               SUBMIT BUTTON
            ----------------------------------- */
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  final qty = int.tryParse(quantityController.text.trim());

                  if (qty == null || qty <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a valid quantity")),
                    );
                    return;
                  }

                  int newStock = updateType == "add"
                      ? stock + qty
                      : stock - qty;

                  if (newStock < 0) newStock = 0;

                  app.updateInventoryItem(widget.itemId, {
                    "stock": newStock,
                  }, global: app.role == "admin");

                  Navigator.pop(context);
                },
                child: const Text(
                  "Update Stock",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ----------------------------------
     UPDATE TYPE CHIP
  ----------------------------------- */
  Widget _updateTypeChip(String type, IconData icon, Color color) {
    final selected = updateType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          updateType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.22)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.white24,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : Colors.white54, size: 20),
            const SizedBox(width: 8),
            Text(
              type == "add" ? "Add Stock" : "Remove Stock",
              style: TextStyle(
                color: selected ? color : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
