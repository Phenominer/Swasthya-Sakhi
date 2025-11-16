import 'package:flutter/material.dart';

class AddInventoryItemScreen extends StatefulWidget {
  const AddInventoryItemScreen({super.key});

  @override
  State<AddInventoryItemScreen> createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            dialogBackgroundColor: const Color(0xFF1E293B),
            colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        expiryController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add Inventory Item",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAME
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter item name" : null,
                decoration: _inputDecoration(
                  label: "Item Name",
                  icon: Icons.medication_rounded,
                ),
              ),

              const SizedBox(height: 18),

              // STOCK
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter stock value";
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return "Enter a valid number";
                  }
                  return null;
                },
                decoration: _inputDecoration(
                  label: "Initial Stock",
                  icon: Icons.numbers_rounded,
                ),
              ),

              const SizedBox(height: 18),

              // EXPIRY
              TextFormField(
                controller: expiryController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) => value == null || value.isEmpty
                    ? "Select expiry date"
                    : null,
                decoration: _inputDecoration(
                  label: "Expiry Date",
                  icon: Icons.calendar_month_rounded,
                ),
                onTap: _pickExpiryDate,
              ),

              const Spacer(),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = {
                        "name": nameController.text.trim(),
                        "stock": int.parse(stockController.text.trim()),
                        "expiry": expiryController.text.trim(),
                      };

                      // Return the item to calling screen
                      Navigator.pop(context, item);
                    }
                  },

                  child: const Text(
                    "Add Item",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.6),
      ),
    );
  }
}
